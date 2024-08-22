
![header](https://firebasestorage.googleapis.com/v0/b/learning-firebase-2d636.appspot.com/o/List_Array_to_CSV_Excel_File.png?alt=media&token=a0dd3779-2698-4a80-9a8a-afc21b10c5c6)

You can create and download a CSV/Excel file with much less code. Do not forget to like the package if this helped you...
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

## Recent Changes in New Version
##### 1. Column headers can now be switched as the first element of each row.
**When setHeadersInFirstRow is set to false like the following code:**
```dart
await  myCSV(header, listOfLists,setHeadersInFirstRow:false,includeNoRow: true, sharing: false);
```
**Output would be:**
![MyCSVFormate](https://firebasestorage.googleapis.com/v0/b/billnews-c5913.appspot.com/o/Screenshot%202024-08-22%20at%209.08.29%E2%80%AFAM.png?alt=media&token=2a799f47-e886-4e71-97f7-036db0b204bb)
**But when setHeadersInFirstRow is set to true, OUTPUT would be:**
![MyCSVFormate](https://firebasestorage.googleapis.com/v0/b/billnews-c5913.appspot.com/o/Screenshot%202024-08-22%20at%209.13.23%E2%80%AFAM.png?alt=media&token=6346565d-ef5e-479e-ac0b-7ec557a09937)

###### You can also set ```dart includeNoRow: false``` to remove No. row/column



##### 2. Compatible with Dart 3 now. Compiled with Flutter 3.22.2 ##3.0.0 & resolved all flutter analyze issues

## Additional information

If you like to contribute to this open source project, you are Welcome .
If you need to make any changes, or find any issue please let me know on github and I will solve it.

**And if you liked the package, don't forget to hit like button.**
## Would love to hear how I can improve this package more...!

| [![Buy me a Coffee ](https://firebasestorage.googleapis.com/v0/b/billnews-c5913.appspot.com/o/New%20Project%20(2).png?alt=media&token=e948c554-5825-4d3b-bf3a-8a885f6a1a74)](https://wa.me/923058431046?text=I%20would%20like%20to%2buy%20you%20a%20coffee%20) | [![Hire me](https://firebasestorage.googleapis.com/v0/b/billnews-c5913.appspot.com/o/New%20Project%20(3).png?alt=media&token=609b2a7f-46fc-4943-b267-787cbc78a1cd)](https://wa.me/923058431046?text=I%20would%20like%20to%2chire%20you%20a%20coffee%20) |
|---|---|

**[Check me out here](https://www.upwork.com/freelancers/billthecoder)**
