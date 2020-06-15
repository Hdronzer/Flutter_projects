
import 'package:contactsapp/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SaveEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class SaveContact extends SaveEvent{
  final User user;

  SaveContact({@required this.user});

  @override
  List<Object> get props => [user];

}

class UpdateUser extends SaveContact {
  final User user;

  UpdateUser({@required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUser extends SaveContact {
  final int id;

  DeleteUser({@required this.id});

  @override
  List<Object> get props => [id];
}