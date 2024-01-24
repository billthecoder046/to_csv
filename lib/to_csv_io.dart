import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

/// {@macro to_csv_method}
Future<void> toCsv(
  List<String> headerRow,
  List<List<String>> content, {
  bool sharing = false,
  String? fileName,
}) async {
  assert(headerRow.isNotEmpty, 'Header row list is empty');
  assert(content.isNotEmpty, 'Content list is empty');
  assert(
    fileName != null && (fileName.endsWith('.csv')),
    'If fileName is not null must be end with `.csv`',
  );

  DateTime now = DateTime.now();

  String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

  List<List<String>> headerAndDataList = [];
  headerAndDataList.add(headerRow);
  for (var dataRow in content) {
    headerAndDataList.add(dataRow);
  }

  String csvData = const ListToCsvConverter().convert(headerAndDataList);

  final bytes = utf8.encode(csvData);
  Uint8List bytes2 = Uint8List.fromList(bytes);
  MimeType type = MimeType.csv;
  if (sharing == true) {
    XFile xFile = XFile.fromData(bytes2);
    await Share.shareXFiles([xFile], text: 'Csv File');
  } else {
    await FileSaver.instance.saveAs(
      name: fileName ?? 'item_export_$formattedDate.csv',
      bytes: bytes2,
      ext: 'csv',
      mimeType: type,
    );
  }
}
