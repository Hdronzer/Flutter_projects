
import 'package:contactsapp/bloc/event/app_event.dart';
import 'package:contactsapp/bloc/state/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  @override
  // TODO: implement initialState
  AppState get initialState => ContactList();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    // TODO: implement mapEventToState
    if (event is AppStarted) {
      yield ContactList();
    }

    if (event is AddUser) {
      yield CreateUser();
    }

    if(event is Update) {
      yield UpdateUser(user: event.user);
    }


    if(event is ShowFavorite) {
      yield FavoriteList();
    }
  }
}