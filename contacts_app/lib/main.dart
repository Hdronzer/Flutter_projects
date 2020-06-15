import 'dart:io';
import 'dart:io';

import 'package:contactsapp/add_user_page.dart';
import 'package:contactsapp/bloc/app_bloc.dart';
import 'package:contactsapp/bloc/event/app_event.dart';
import 'package:contactsapp/bloc/event/list_event.dart';
import 'package:contactsapp/bloc/list_bloc.dart';
import 'package:contactsapp/bloc/state/app_state.dart';
import 'package:contactsapp/bloc/state/list_state.dart';
import 'package:contactsapp/favorite_page.dart';
import 'package:contactsapp/update_user_page.dart';
import 'package:contactsapp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contactsapp/model/user.dart';

void main() {
  runApp(
      BlocProvider(
        create: (context) =>
        AppBloc(),
        child: ContactApp(),
      )
  );
}

class ContactApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AppBloc, AppState> (
        // ignore: missing_return
        builder: (context, state) {
          if(state is CreateUser)
            return NewContact();

          if(state is ContactList)
            return ContactListPage();

          if(state is UpdateUser)
            return UpdateContact(user:state.user);

          if(state is FavoriteList)
            return FavoritePage();
        }
      ),
    );
  }
}

class ContactListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(80.0),
            child: Text('Contact list'),
          ),
      ),
      drawer: AppDrawer(),
      body: BlocProvider(
        create: (context) =>
          ListBloc()..add(Fetch()),
        child: HomePage(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            BlocProvider.of<AppBloc>(context).add(AddUser());
          },
          icon: Icon(Icons.add),
          label: Text("Add User")
      ),
    );
  }

}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  AppBloc _bloc;
  int _counter = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BlocProvider.of<AppBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _onInsertPressed() {

    }
    return Container(
      child: BlocBuilder<ListBloc,ListState> (
                // ignore: missing_return
                  builder: (context, state) {
                    if (state is ListUninitialized) {
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
                    }

                    if (state is ListError) {
                      return Center(
                        child: Text('Failed to fetch contacts'),
                      );
                    }

                    if (state is ListEmpty) {
                      return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text('No Contacts Present',
                                      style: TextStyle(
                                        //color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text('Hit the button to add'),
                                ),
                              ]
                          )
                      );
                    }

                    if(state is ListLoaded)
                      return ListView(children:_getListData(state.users));
                  }
              ),
      );
  }

  List<Widget> _getListData(List<User> listData) {
    List<Widget> rows = [];
    if(listData == null) {
      return rows;
    }
    for(var data in listData) {

      rows.add(Padding(
        padding: EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 50,
              margin: EdgeInsets.all(5),
              child: data.path.isEmpty ? Icon(Icons.person):Image.file(File(data.path)),
            ),
            Container(
              width: 270,
              margin:EdgeInsets.all(5.0),
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
              child: Text(data.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _bloc.add(Update(user: data));
                },
              ),
            )
          ],
        ),
      )
      );
    }
    return rows;
  }
}
