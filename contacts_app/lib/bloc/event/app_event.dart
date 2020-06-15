
import 'package:contactsapp/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AppEvent {}

class AddUser extends AppEvent {}

class Update extends AppEvent {
  final User user;

  Update({@required this.user});

}

class ShowFavorite extends AppEvent{}