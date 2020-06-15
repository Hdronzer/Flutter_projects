
import 'package:contactsapp/bloc/app_bloc.dart';
import 'package:contactsapp/bloc/event/app_event.dart';
import 'package:contactsapp/bloc/event/list_event.dart';
import 'package:contactsapp/bloc/favorite_bloc.dart';
import 'package:contactsapp/bloc/state/list_state.dart';
import 'package:contactsapp/model/user.dart';
import 'package:contactsapp/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<AppBloc>(context).add(AppStarted());
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.all(40.0),
            child: Text('Favorite Contact List'),
          ),
        ),
        drawer: AppDrawer(),
        body: BlocProvider(
          create: (context) =>
          FavoriteBloc()..add(Fetch()),
          child: FavHomePage(),
        ),
      )
    );
  }
}

class FavHomePage extends StatefulWidget {
  FavHomePage({Key key}) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavHomePage> {
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
    return Container(
      child: BlocBuilder<FavoriteBloc,ListState> (
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
                child: Text('Something went wrong',
                    style: TextStyle(
                      //color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
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
                          child: Text('No Contacts Marked Favorite',
                              style: TextStyle(
                                //color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
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
              child: Icon(Icons.contacts),
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
