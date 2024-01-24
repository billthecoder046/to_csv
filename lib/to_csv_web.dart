import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

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
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..download = fileName ?? 'item_export_$formattedDate.csv';
  html.document.body!.children.add(anchor);
  anchor.click();
  html.Url.revokeObjectUrl(url);
}
