
import 'package:contactsapp/model/user.dart';
import 'package:equatable/equatable.dart';

abstract class ListState extends Equatable{
  const ListState();

  @override
  List<Object> get props => [];
}

class ListUninitialized extends ListState {}

class ListError extends ListState {}

class ListEmpty extends ListState {}

class ListLoaded extends ListState {
  final List<User> users;

  const ListLoaded({
    this.users,
  });

  ListLoaded copyWith({ // copy an instance of ListLoaded and update its properties conveniently
    List<User> users,
  }) {
    return ListLoaded(
      users: users ?? this.users,
    );
  }

  @override
  List<Object> get props => [users];

  @override
  String toString() =>
      'ListLoaded { users: ${users.length}}';
}