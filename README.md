<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
![header](https://firebasestorage.googleapis.com/v0/b/learning-firebase-2d636.appspot.com/o/List_Array_to_CSV_Excel_File.png?alt=media&token=a0dd3779-2698-4a80-9a8a-afc21b10c5c6)

You can create and download a CSV/Excel file with much less code. Do not forget to like the package if this helped you...

## Recent Changes in New Version
* Compatible with Dart 3 now. Compiled with Flutter 3.22.2 ##3.0.0 & resolved all flutter analyze issues

## How to use it?

* Firstly, add to_csv as a dependency in your pubspec.yaml file.
* And import this as in your dart file:
```dart
   import 'package:to_csv/to_csv.dart' as exportCSV;
```

* In your onPressed/onTap function (or wherever you like), create a list of Strings that will be the Header of your table or excel file.
```dart
 List<String> header = [];
header.add('No.');
header.add('User Name');
header.add('Mobile');
header.add('ID Number');
```
* Also create a two lists which contains your list of rows as List<String>
```dart
  List<List<String>> listOfLists = []; //Outter List which contains the data List
  List<String> data1 = ['1','Bilal Saeed','1374934','912839812']; //Inner list which contains Data i.e Row
  List<String> data2 = ['2','Ahmar','21341234','192834821']; //Inner list which contains Data i.e Row
```
**Note: Length of elements present in Rows should be equal to the length of header list length**

* Now add your data variables in listOfVisitor which is List of List of Strings actually.
```dart
  listOfLists.add(data1);
  listOfLists.add(data2);
```
* Finally pass header and listOfVisitors to the package function like this:
```dart
 exportCSV.myCSV(header, listOfLists);
```
And your csvFile will be downloaded in no minutes.
Open it on excel or in any other app and Enjoy!

### Your final output will be:
![A pretty Tiger]( https://firebasestorage.googleapis.com/v0/b/learning-firebase-2d636.appspot.com/o/Screenshot%202022-10-21%20at%203.48.05%20PM.png?alt=media&token=3023f9a3-147a-4f0c-9d78-e814dba72df0)

## Configuration FOR IOS:
Go to your project folder, ios/Runner/info.plist and Add these keys:
```dart
    <key>LSSupportsOpeningDocumentsInPlace</key>
    <true/>
    <key>UIFileSharingEnabled</key>
    <true/>
```
![iOSkeysImage](https://raw.githubusercontent.com/incrediblezayed/file_saver/main/images/ios.png)


## Or Configure in XCode:
Open Your Project in XCode (Open XCode -> Open a project or file -> Your_Project_Folder/ios/Runner.xcworkspace) Open info.plist Add these rows:

Application supports iTunes file sharing (Boolean -> Yes)

Supports opening documents in place (Boolean -> Yes)
![forIoSImage](https://raw.githubusercontent.com/incrediblezayed/file_saver/main/images/iOSXcode.png)


## Additional information

If you like to contribute to this open source project, you are Welcome . 
If you need to make any changes, or find any issue please let me know on github and I will solve it.

**And if you liked the package, don't forget to hit like button.**
## Would love to hear how we can improve more this project...!

[![Buy me a Coffee ](https://wa.me/923058431046?text=I%20would%20like%20to%20buy%20you%20a%20coffee%20)](https://wa.me/923058431046?text=I%20would%20like%20to%20buy%20you%20a%20coffee%20)

**[Hire me](https://wa.me/923058431046?text=I%20would%20like%20to%20hire%20you%20a%20coffee%20)**

**[Check my other projects,plugins and products](https://billthecoder.web.app/#/)**
