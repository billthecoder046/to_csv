library to_csv;

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as pth_prov;
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

Future myCSV(
    List<String> headerRow,
    List<List<String>> listOfListOfStrings, {
      bool setHeadersInFirstRow = true,
      bool includeNoRow = true,
      bool sharing = false,
      String? fileName,
      String? fileTimeStamp,
      Map<int, int>? emptyRowsConfig, // Renamed from emptyRowsAfter
      bool removeDuplicates = false, // Check for duplicates in columns
      bool showDuplicateValue = false, // Indicate duplicated entry
      int? noDuplicatedCheckAfterSpecificRow, // New parameter to stop duplicate check after this row index
    }) async {
  if (kDebugMode) {
    print("***** Gonna Create csv");
  }

  String givenFileName = "${fileName ?? 'item_export'}_";
  DateTime now = DateTime.now();
  String formattedDate = fileTimeStamp ?? DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

  List<List<String>> headerAndDataList = [];

  if (setHeadersInFirstRow) {
    // Add the headers to the first row
    headerAndDataList.add(includeNoRow ? headerRow : headerRow.sublist(1));
    headerAndDataList.addAll(
      listOfListOfStrings.map((row) => includeNoRow ? row : row.sublist(1)).toList(),
    );
  } else {
    // Transpose the data so that each header is the first element in its row
    for (int i = 0; i < headerRow.length; i++) {
      if (includeNoRow || i > 0) {
        List<String> rowData = [headerRow[i]];
        for (int j = 0; j < listOfListOfStrings.length; j++) {
          rowData.add(listOfListOfStrings[j][i]);
        }
        headerAndDataList.add(rowData);
      }
    }
  }

  // Remove duplicates if the removeDuplicates parameter is true
  if (removeDuplicates) {
    if (setHeadersInFirstRow) {
      for (int col = 0; col < headerAndDataList[0].length; col++) {
        Set<String> uniqueValues = {};
        for (int row = 1; row < headerAndDataList.length; row++) {
          // Check for duplicates only up to the specified row index
          if (noDuplicatedCheckAfterSpecificRow != null && row > noDuplicatedCheckAfterSpecificRow) {
            break;
          }
          String cellValue = headerAndDataList[row][col];
          if (uniqueValues.contains(cellValue)) {
            headerAndDataList[row][col] = showDuplicateValue ? "DUPLICATE" : ""; // Replace with empty value
          } else {
            uniqueValues.add(cellValue);
          }
        }
      }
    } else {
      for (int row = 0; row < headerAndDataList.length; row++) {
        Set<String> uniqueValues = {};
        for (int col = 1; col < headerAndDataList[row].length; col++) {
          // Check for duplicates only up to the specified row index
          if (noDuplicatedCheckAfterSpecificRow != null && row > noDuplicatedCheckAfterSpecificRow) {
            break;
          }
          String cellValue = headerAndDataList[row][col];
          if (uniqueValues.contains(cellValue)) {
            headerAndDataList[row][col] = showDuplicateValue ? "DUPLICATE" : ""; // Replace with empty value
          } else {
            uniqueValues.add(cellValue);
          }
        }
      }
    }
  }

  // Insert empty rows after the specified rows using the map
  if (emptyRowsConfig != null) {
    emptyRowsConfig.forEach((rowIndex, rowCount) {
      rowIndex += emptyRowsConfig.entries
          .where((entry) => entry.key < rowIndex)
          .map((entry) => entry.value)
          .fold(0, (previous, current) => previous + current);
      if (rowIndex < headerAndDataList.length) {
        List<String> emptyRow = List.filled(headerAndDataList[0].length, "");
        for (int j = 0; j < rowCount; j++) {
          headerAndDataList.insert(rowIndex + j, emptyRow);
        }
      }
    });
  }

  String csvData = const ListToCsvConverter().convert(headerAndDataList);

  if (kIsWeb) {
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..download = '$givenFileName$formattedDate.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  } else if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isWindows ||
      Platform.isMacOS) {
    final bytes = utf8.encode(csvData);
    Uint8List bytes2 = Uint8List.fromList(bytes);
    MimeType type = MimeType.csv;
    if (sharing == true) {
      String? unknownValue = await FileSaver.instance.saveAs(
          name: '$givenFileName$formattedDate',
          bytes: bytes2,
          ext: 'csv',
          mimeType: type);
      XFile? myFile;
      if (unknownValue != null) {
        myFile = await convertFilePathToXFile(unknownValue);
      }
      if (myFile != null) {
        await Share.shareXFiles([myFile], text: 'Csv File');
      }
    } else {
      await FileSaver.instance.saveAs(
          name: '$givenFileName$formattedDate',
          bytes: bytes2,
          ext: 'csv',
          mimeType: type);
    }
  }
}

Future<XFile?> convertFilePathToXFile(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) {
    return null;
  }

  final directory = await pth_prov.getApplicationDocumentsDirectory();
  final fileName = basename(filePath);

  final targetPath = join(directory.path, fileName);
  await file.copy(targetPath);
  return XFile(targetPath);
}
