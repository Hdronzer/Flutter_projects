
import 'package:contactsapp/bloc/event/save_event.dart';
import 'package:contactsapp/bloc/state/save_state.dart';
import 'package:contactsapp/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveBloc extends Bloc<SaveEvent, SaveState> {
  final UserRepository _userRepo = UserRepository.repo;

  @override
  // TODO: implement initialState
  SaveState get initialState => InitUser();

  @override
  Stream<SaveState> mapEventToState(SaveEvent event) async*{
    if(event is SaveContact) {
      if(event.user.name.isEmpty) {
        yield NameMissing();
      }else {
        try {
          print('fav = ${event.user.fav}');
          await _userRepo.insertRecord(event.user);
          yield SaveSuccess();
        }catch (ex) {
          yield SaveFail();
        }
      }
    }
  }

}