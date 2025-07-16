import 'package:flutter/material.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo to_csv Package',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo to_csv package'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> header = [];
  List<List<String>> listOfLists = []; //Outter List which contains the data List
  List<String> data1 = ['1','Bilal Saeed','1374934','912839812']; //Inner list which contains Data i.e Row
  List<String> data2 = ['2','Ahmar','21341234','192834821']; //Inner list which contains Data i.e Row

  _addHeaderToList(){
    header.add('No.');
    header.add('User Name');
    header.add('Mobile');
    header.add('ID Number');
    listOfLists.add(header);
    listOfLists.add(data1);
    listOfLists.add(data2);
  }
  _downloadFile(){
    exportCSV.myCSV(header, listOfLists, sharing: true);
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addHeaderToList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  const <Widget>[
              Text(
              'Press floating button to download',
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadFile,
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
