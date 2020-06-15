
import 'package:contactsapp/bloc/event/list_event.dart';
import 'package:contactsapp/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state/list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final UserRepository _userRepo = UserRepository.repo;

  @override
  // TODO: implement initialState
  ListState get initialState => ListUninitialized();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    // TODO: implement mapEventToState
    final currentState = state;
    if(event is Fetch) {

      if(currentState is ListUninitialized)
        yield ListUninitialized();
      try {
        final users = await _userRepo.fetchData();
        print('list size = ${users.length}');
        if(users.isEmpty)
          yield ListEmpty();
        else
          yield ListLoaded(users : users);
      }catch (_) {
        yield ListError();
      }
      return;
    }
  }

}