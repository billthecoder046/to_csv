import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> header = [];
  List<List<String>> listOfLists = [];
  List<String> data1 = [
    '1',
    'Bilal Saeed',
    '1374934',
    '912839812'
  ]; //Inner list which contains Data i.e Row
  List<String> data2 = ['2', 'Ahmar Ch.', '2134123', '192834821'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    header.add('No.');
    header.add('User Name');
    header.add('Mobile');
    header.add('ID Number');
    listOfLists.add(data1);
    listOfLists.add(data2); //Inner list which contains Data i.e Row
  }
  myData(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("My CSV Data",style: TextStyle(color: Colors.black87),),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:  Border.all(color: Colors.black, width: 1.0)
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 30,
          alignment: Alignment.center,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: header.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(left:26.0),
                  child: Text(header[i].toString()),
                );
              }),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:  Border.all(color: Colors.black, width: 1.0)
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 30,
          alignment: Alignment.center,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data1.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(left:26.0),
                  child: Text(data1[i].toString()),
                );
              }),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:  Border.all(color: Colors.black, width: 1.0)
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 30,
          alignment: Alignment.center,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data2.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(left:26.0),
                  child: Text(data2[i].toString()),
                );
              }),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            myData(context),
            InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.yellow,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copy),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Generate CSV")
                    ],
                  ),
                ),
                onTap: () {
                  exportCSV.myCSV(header, listOfLists);
                })
          ],
        ),
      ),
    );
  }
}
