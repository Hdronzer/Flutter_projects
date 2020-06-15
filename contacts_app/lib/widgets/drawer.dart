
import 'package:contactsapp/add_user_page.dart';
import 'package:contactsapp/bloc/app_bloc.dart';
import 'package:contactsapp/bloc/event/app_event.dart';
import 'package:contactsapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    var _bloc = BlocProvider.of<AppBloc>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.contacts, text: 'Contacts',
            onTap: () => _bloc.add(AppStarted())),
          _createDrawerItem(icon: Icons.add_circle, text: 'Add User',
            onTap: () => _bloc.add(AddUser())),
          _createDrawerItem(icon: Icons.favorite_border, text: 'Favorite',
              onTap: () => _bloc.add(ShowFavorite())),
          ListTile(
            title: Text('Version 1.0'),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:  AssetImage('res/images/drawer_header_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Select Page",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

}