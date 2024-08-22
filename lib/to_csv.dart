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

Future myCSV(List<String> headerRow, List<List<String>> listOfListOfStrings,
    {bool setHeadersInFirstRow = true,
    bool includeNoRow = true,
    bool sharing = false,
    String? fileName,
    String? fileTimeStamp}) async {
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

    // Add the data rows directly
    headerAndDataList.addAll(
        listOfListOfStrings.map((row) => includeNoRow ? row : row.sublist(1)).toList());
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
      if (kDebugMode) {
        print("When sharing is true Bilal Saeed 2314123123123");
      }

      String? unknownValue = await FileSaver.instance.saveAs(
          name: '$givenFileName$formattedDate',
          bytes: bytes2,
          ext: 'csv',
          mimeType: type);
      if (kDebugMode) {
        print("Unknown value $unknownValue");
      }
      XFile? myFile;
      if (unknownValue != null) {
        myFile = await convertFilePathToXFile(unknownValue);
      }
      if (myFile != null) {
        await Share.shareXFiles([myFile], text: 'Csv File');
      }
    } else {
      String? unknownValue = await FileSaver.instance.saveAs(
          name: '$givenFileName$formattedDate',
          bytes: bytes2,
          ext: 'csv',
          mimeType: type);
      if (kDebugMode) {
        print("Unknown value $unknownValue");
      }
    }
  }
}

Future<XFile?> convertFilePathToXFile(String filePath) async {
  // Check if the file exists
  final file = File(filePath);
  if (!await file.exists()) {
    return null; // Or handle the error as needed
  }

  // Create an XFile from the file path
  final directory = await pth_prov.getApplicationDocumentsDirectory();
  final fileName = basename(filePath);
  if (kDebugMode) {
    print("file name: $fileName");
  }

  final targetPath = join(directory.path, fileName);
  if (kDebugMode) {
    print("My target path: $targetPath");
  }

  // Copy the file to the app's document directory (optional)
  // This step is optional, but it can be useful for managing files within your app
  await file.copy(targetPath);
  return XFile(targetPath);
}
