
import 'dart:convert';
import 'dart:io';

import 'package:contactsapp/bloc/event/app_event.dart';
import 'package:contactsapp/bloc/event/save_event.dart';
import 'package:contactsapp/bloc/state/save_state.dart';
import 'package:contactsapp/bloc/update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/app_bloc.dart';
import 'model/user.dart';
bool flag = false;
class UpdateContact extends StatefulWidget {
final User user;
  UpdateContact({this.user});

  @override
  State<StatefulWidget> createState() {
    return _UserAppBarState();
  }
}

class _UserAppBarState extends State<UpdateContact> {
  var icon;

  @override
  void initState() {
    super.initState();
    flag = widget.user.fav == 1?true:false;
    icon = flag?Icons.star:Icons.star_border;
  }
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(76.0),
                    child: Text('Update Contact')
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
        body:  BlocProvider(
          create: (context) {
            return UpdateBloc();
          },
          child: UpdateUserHomePage(user: widget.user,),
        ),
      )
    );
  }

}

// ignore: must_be_immutable
class UpdateUserHomePage extends StatefulWidget {
  UpdateUserHomePage({Key key, this.user}) : super(key: key);

  User user;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UpdateUserHomePage> {
  final name = TextEditingController();
  final mobile = TextEditingController();
  final landline = TextEditingController();
  var _image;
  int count = 0;
  String path;
  AppBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = null;
    path = widget.user.path;
    name.text = widget.user.name;
    mobile.text = widget.user.mobile;
    landline.text = widget.user.landLine;
    _bloc = BlocProvider.of<AppBloc>(context);
    _getImageData();
  }

  void _getImageData() async{
    if(widget.user.path.isEmpty)
      return;

    _image = File(path);
    setState(() {
      count++;
    });
  }

  void _onCameraPressed() async{
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    path = image.path;
    setState(() {
      _image = File(image.path);
    });
  }

  void _onGallerySelected() async{
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    path = image.path;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateBloc, SaveState>(
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
      child: BlocBuilder<UpdateBloc, SaveState>(
        // ignore: missing_return
          builder: (context, state) {
            if (state is SaveSuccess) {
              _bloc.add(AppStarted());
            }

            if (state is SaveFail) {
              AlertDialog(
                content: Text('Could Not Update. Please Try again'),
              );
            }

            if (state is SaveFail) {
              AlertDialog(
                content: Text('Could Not Delete. Please Try again'),
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
                                            image:_image == null ?AssetImage('res/images/icon_person.png'):FileImage(_image),
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
                          Container(
                            margin: EdgeInsets.all(5),
                            child: RaisedButton(
                                child: Text('Update'),
                                // ignore: missing_return
                                onPressed: () {
                                  if(_image != null)
                                    path = _image.path;


                                  final User _user = User.fromId(
                                      id: widget.user.id,
                                      name: name.text,
                                      mobile: mobile.text,
                                      landLine: landline.text,
                                      path: path,
                                      fav: flag?1:0
                                  );
                                  BlocProvider.of<UpdateBloc>(context).add(UpdateUser(user: _user));
                                }
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            child: RaisedButton(
                                child: Text('Delete'),
                                // ignore: missing_return
                                onPressed: () {
                                  BlocProvider.of<UpdateBloc>(context).add(DeleteUser(id: widget.user.id));
                                }
                            ),
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