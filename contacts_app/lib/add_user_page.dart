
import 'dart:convert';
import 'dart:io';

import 'package:contactsapp/bloc/event/app_event.dart';
import 'package:contactsapp/bloc/event/save_event.dart';
import 'package:contactsapp/bloc/save_bloc.dart';
import 'package:contactsapp/bloc/state/save_state.dart';
import 'package:contactsapp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/app_bloc.dart';
import 'model/user.dart';

bool flag = false;

class NewContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserAppBarState();
  }
}

class _UserAppBarState extends State<NewContact> {
  var icon = Icons.star_border;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          BlocProvider.of<AppBloc>(context).add(AppStarted());
          return;
        },
      child: Scaffold(
        appBar: AppBar(
            title: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Text('Add New Contact')
                ),
                Padding(
                    padding: EdgeInsets.all(0.0),
                    child:  IconButton(
                      icon: Icon(icon),
                      onPressed: () {
                        flag = !flag;
                        if(flag) {
                          setState(() {
                            icon = Icons.star;
                          });
                        }else {
                          setState(() {
                            icon = Icons.star_border;
                          });
                        }
                      },
                    )
                )
              ],
            )
        ),
        drawer: AppDrawer(),
        body:  BlocProvider(
          create: (context) {
            return SaveBloc();
          },
          child: CreateUserHomePage(),
        ),
      )
    );

  }

}

class CreateUserHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<CreateUserHomePage> {
  final name = TextEditingController();
  final mobile = TextEditingController();
  final landline = TextEditingController();
  File _image;
  AppBloc _bloc;
  String path;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BlocProvider.of<AppBloc>(context);
    _image = null;
    path = '';
  }

  void _onCameraPressed() async{
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }

  void _onGallerySelected() async{
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<SaveBloc, SaveState>(
      listener: (context, state) {
        if (state is NameMissing) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Name cannot be blank'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<SaveBloc, SaveState>(
        // ignore: missing_return
        builder: (context, state) {
          if (state is SaveSuccess) {
            _bloc.add(AppStarted());
          }

          if (state is SaveFail) {
             AlertDialog(
              content: Text('Please Try again'),
            );
          }

          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal:0,vertical: 20),
                        child: Ink(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 3.0),
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            //This keeps the splash effect within the circle
                            borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                            onTap: () {
                              Widget camera = FlatButton(
                                child: Text("Camera"),
                                onPressed: () {
                                  _onCameraPressed();
                                  Navigator.pop(context);
                                }
                              );

                              Widget gallery = FlatButton(
                                child: Text("Gallery"),
                                onPressed: () {
                                  _onGallerySelected();
                                  Navigator.pop(context);
                                }
                              );

                              AlertDialog imageAlert = AlertDialog(
                                content: Text('Select Image Source',
                                style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                                actions: [
                                camera,
                                gallery
                                ],
                              );

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                return imageAlert;
                                },
                              );
                            },
                            child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:_image == null ?AssetImage('res/images/icon_person.png'):FileImage(_image),//FileImage(_image),
                                        fit: BoxFit.fill
                                    ),
                                  )
                                )
                          ),
                        )
                      )
                    ),
                    Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(3.0),
                            child: Text('Name',
                                style: TextStyle(
                                  //color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                          Container(
                            margin: EdgeInsets.all(7.0),
                          ),
                          Container(
                            margin: EdgeInsets.all(3.0),
                            height: 35,
                            width: 280,
                            child: TextField(
                              controller: name,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Name',
                              ),
                            ),
                          )
                        ]
                    ),
                    Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(3.0),
                            padding: EdgeInsets.all(4.0),
                            child: Text('Mobile',
                                style: TextStyle(
                                  //color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                          Container(
                            margin: EdgeInsets.all(3.0),
                            height: 35,
                            width: 283,
                            child: TextField(
                              controller: mobile,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mobile No',
                              ),
                            ),
                          )
                        ]
                    ),
                    Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(3.0),
                            child: Text('Landline',
                                style: TextStyle(
                                  //color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                          Container(
                            margin: EdgeInsets.all(3.0),
                            height: 35,
                            width: 280,
                            child: TextField(
                              controller: landline,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Landline No',

                              ),
                            ),
                          )
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                              child: Text('Save'),
                              // ignore: missing_return
                              onPressed: () {
                                String image = "";
                                if(_image != null) {
                                  path = _image.path;
                                }

                                print('image = $image');
                                final User _user = User(
                                    name: name.text,
                                    mobile: mobile.text,
                                    landLine: landline.text,
                                    path: path,
                                    fav: flag?1:0
                                );
                                BlocProvider.of<SaveBloc>(context).add(SaveContact(user: _user));
                              }
                          )
                        ]
                    ),
                  ]
              ),
            );

        }
      ),
    );
  }
}