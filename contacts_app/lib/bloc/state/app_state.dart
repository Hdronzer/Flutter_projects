
import 'package:contactsapp/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AppState extends Equatable{
  const AppState();

  @override
  List<Object> get props => [];
}

class CreateUser extends AppState{}

class ContactList extends AppState {}

class UpdateUser extends AppState {
  final User user;

  const UpdateUser({@required this.user});
}

class FavoriteList extends AppState{}

