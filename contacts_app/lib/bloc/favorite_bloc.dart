
import 'package:contactsapp/bloc/event/list_event.dart';
import 'package:contactsapp/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state/list_state.dart';

class FavoriteBloc extends Bloc<ListEvent, ListState> {
  final UserRepository _userRepo = UserRepository.repo;

  @override
  ListState get initialState => ListUninitialized();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    final currentState = state;
    if(event is Fetch) {

      if(currentState is ListUninitialized)
        yield ListUninitialized();
      try {
        final users = await _userRepo.fetchFavData();
        if(users.isEmpty)
          yield ListEmpty();
        else
          yield ListLoaded(users : users);
      }catch (ex) {
        print(ex);
        yield ListError();
      }
      return;
    }
  }

}