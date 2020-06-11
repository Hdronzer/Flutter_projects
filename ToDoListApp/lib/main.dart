import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'ToDoModel.dart';

void main() => runApp(ToDoListPage());

class ToDoListPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListHomePage(title: 'Todo List'),
    );
  }
}

class ListHomePage extends StatefulWidget {
  ListHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ListHomePage> {
  int _counter = 0;
  //ToDoList rowData =  ToDoList();
  Future<ToDoList> rowData;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadData();
    rowData = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.title)
          ],
        )
      ),
      body: FutureBuilder<ToDoList>(
        future: rowData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(children:_getListData(snapshot.data));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Something went wrong',
                        style: TextStyle(
                        //color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Give it another try'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          rowData = loadData();
                        });
                      },
                      child: Text('Reload'),
                    ),
                  )
                ],
              ),
            );
          }
          // By default, show a loading spinner.
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Text('Loading Data...')
              ],
            )
          );
        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<ToDoList> loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/todos";
    http.Response response = await http.get(dataURL);
    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
//      setState(() {
//        return ToDoList.fromJson(jsonData);
//      });
      return ToDoList.fromJson(jsonData);
    }else {
      throw Exception('Failed to load data');
    }
  }

  List<Widget> _getListData(ToDoList data) {
    List<Widget> rows = [];
    var listData = data.list;
    if(listData == null) {
      return rows;
    }
    for(var data in listData) {
      rows.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Id = "+data.id.toString()),
            Text("Title = " +data.title),
            Text("Completed = " + data.completed.toString())
          ],
        ),
      )
      );
    }
    return rows;
  }
}
