library to_csv;

// Import necessary Dart and Flutter packages
import 'dart:convert'; // Provides tools for encoding and decoding JSON, UTF-8, etc.
import 'dart:io'; // Provides file and socket operations.

import 'package:csv/csv.dart'; // Library to convert lists to CSV format.
import 'package:file_saver/file_saver.dart'; // Library to save files on various platforms.
import 'package:flutter/foundation.dart'; // Provides foundational classes and functions.
import 'package:intl/intl.dart'; // Library for internationalization and formatting dates.
import 'package:path/path.dart'; // Library to handle file paths across platforms.
import 'package:path_provider/path_provider.dart' as pth_prov; // Library to get the common paths.
import 'package:share_plus/share_plus.dart'; // Library to share content on different platforms.
import 'package:universal_html/html.dart' as html; // Library for handling HTML elements in Flutter Web.

// Function to generate and save/share a CSV file based on the provided data.
Future myCSV(
    List<String> headerRow, // List of header titles.
    List<List<String>> listOfListOfStrings, // 2D list containing the data rows.
        {
      bool setHeadersInFirstRow = false, // Flag to decide if headers should be in the first row.
      bool includeNoRow = true, // Flag to include the first column (row numbers).
      bool sharing = false, // Flag to decide whether to share the file after creation.
      String? fileName, // Optional custom file name.
      String? fileTimeStamp, // Optional timestamp for the file name.
      Map<int, int>? emptyRowsConfig, // Map to insert empty rows after specific rows.
      bool removeDuplicates = false, // Flag to remove duplicate values in the CSV.
      bool showDuplicateValue = false, // Flag to show the word "DUPLICATE" instead of removing it.
      int? noDuplicatedCheckAfterSpecificRow, // Row index after which duplicate checks will stop.
      int? transposeAfterRow, // Row index after which the data will be transposed.
    }
    ) async {
  if (kDebugMode) {
    print("***** Gonna Create csv");
  }

  // Generate the file name with a timestamp.
  String givenFileName = "${fileName ?? 'item_export'}_";
  DateTime now = DateTime.now();
  String formattedDate = fileTimeStamp ?? DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

  List<List<String>> headerAndDataList = [];

  if (setHeadersInFirstRow) {
    // If setHeadersInFirstRow is true, add headers as the first row and then add the data.
    headerAndDataList.add(includeNoRow ? headerRow : headerRow.sublist(1));
    headerAndDataList.addAll(
      listOfListOfStrings.map((row) => includeNoRow ? row : row.sublist(1)).toList(),
    );
  } else {
    // If setHeadersInFirstRow is false, transpose the data so that each header becomes the first element in its row.
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

  // Transpose the data after a specific row, if the parameter is set.
  if (transposeAfterRow != null && transposeAfterRow < headerAndDataList.length) {
    List<List<String>> preTranspose = headerAndDataList.sublist(0, transposeAfterRow);
    List<List<String>> toTranspose = headerAndDataList.sublist(transposeAfterRow);

    List<List<String>> transposedData = [];

    for (int i = 0; i < toTranspose[0].length; i++) {
      List<String> newRow = [];
      for (int j = 0; j < toTranspose.length; j++) {
        newRow.add(toTranspose[j][i]);
      }
      transposedData.add(newRow);
    }

    headerAndDataList = [...preTranspose, ...transposedData];
  }

  // Remove duplicates if the removeDuplicates flag is true.
  if (removeDuplicates) {
    if (setHeadersInFirstRow) {
      // For each column, remove duplicates based on the unique values found up to a specific row.
      for (int col = 0; col < headerAndDataList[0].length; col++) {
        Set<String> uniqueValues = {};
        for (int row = 1; row < headerAndDataList.length; row++) {
          if (noDuplicatedCheckAfterSpecificRow != null && row > noDuplicatedCheckAfterSpecificRow) {
            break;
          }
          String cellValue = headerAndDataList[row][col];
          if (uniqueValues.contains(cellValue)) {
            headerAndDataList[row][col] = showDuplicateValue ? "DUPLICATE" : ""; // Replace duplicates with empty value or "DUPLICATE".
          } else {
            uniqueValues.add(cellValue);
          }
        }
      }
    } else {
      // Same as above, but for the data if headers are not set in the first row.
      for (int row = 0; row < headerAndDataList.length; row++) {
        Set<String> uniqueValues = {};
        for (int col = 1; col < headerAndDataList[row].length; col++) {
          if (noDuplicatedCheckAfterSpecificRow != null && row > noDuplicatedCheckAfterSpecificRow) {
            break;
          }
          String cellValue = headerAndDataList[row][col];
          if (uniqueValues.contains(cellValue)) {
            headerAndDataList[row][col] = showDuplicateValue ? "DUPLICATE" : "";
          } else {
            uniqueValues.add(cellValue);
          }
        }
      }
    }
  }

  // Insert empty rows at specific indices as defined by the emptyRowsConfig map.
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

  // Convert the list of data into a CSV formatted string.
  String csvData = const ListToCsvConverter().convert(headerAndDataList);

  // Save or share the CSV file depending on the platform.
  if (kIsWeb) {
    // For web platforms, create a downloadable link for the CSV file.
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
    // For mobile and desktop platforms, save the CSV file and optionally share it.
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

// Helper function to convert a file path into an XFile (used for sharing files).
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
