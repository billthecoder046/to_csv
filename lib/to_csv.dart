library to_csv;

import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:universal_html/html.dart' as html;

Future myCSV(List<String> headerRow, List<List<String>> listOfListOfStrings,
    {bool sharing = false, String? fileName, String? fileTimeStamp}) async {
  debugPrint("***** Gonna Create cv");

  //* A list of header
  //* A single ***list*** that will contain the list of rows   []
  //*
  // int lengthOfHeaderRow = headerRow.length;
  // int lengthOfListOfList = listOfListOfStrings.first.length;
  //  bool valuesInListOfListAreSame = false;
  // if(lengthOfHeaderRow == lengthOfListOfList){
  //   listOfListOfStrings.forEach((element) {
  //     if(element.length == lengthOfHeaderRow){
  //       valuesInListOfListAreSame = true;
  //     }else{
  //       valuesInListOfListAreSame = false;
  //       return;
  //     }

  //   });
  //   //Now that its confirmed that length of header elements and row elemnts are same lets create the csvFile
  // }

  //specify file name
  String givenFileName = "${fileName ?? 'item_export'}_";

  DateTime now = DateTime.now();

  //allow user to specify a specific timestamp that was saved with record
  String formattedDate =
      fileTimeStamp ?? DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

  //create the final list of lists containing the header and the data
  List<List<String>> headerAndDataList = [];
  headerAndDataList.add(headerRow);
  for (var dataRow in listOfListOfStrings) {
    headerAndDataList.add(dataRow);
  }

  String csvData = const ListToCsvConverter().convert(headerAndDataList);

  if (kIsWeb) {
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$givenFileName$formattedDate.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  } else if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isWindows ||
      Platform.isMacOS) {
/*    Directory? director = await getExternalStorageDirectory();
    debugPrint('2');
    final File file = await (File('${director!.path}/item_export_$formattedDate.csv').create());
    debugPrint('3');
    await file.writeAsString(csvData).then((value) => debugPrint("File created and downloaded"));*/

    final bytes = utf8.encode(csvData);
    Uint8List bytes2 = Uint8List.fromList(bytes);
    MimeType type = MimeType.csv;
    String? unknownValue = await FileSaver.instance.saveAs(
        name: '$givenFileName$formattedDate',
        bytes: bytes2,
        ext: 'csv',
        mimeType: type);
    print("Unknown value $unknownValue");
    if (sharing == true) {
      XFile xFile = XFile.fromData(bytes2);
      await Share.shareXFiles([xFile], text: 'Csv File');
    }
  }
}
