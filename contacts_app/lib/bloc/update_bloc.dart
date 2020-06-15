
import 'package:contactsapp/bloc/event/save_event.dart';
import 'package:contactsapp/bloc/state/save_state.dart';
import 'package:contactsapp/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateBloc extends Bloc<SaveEvent, SaveState> {
  final UserRepository _userRepo = UserRepository.repo;

  @override
  // TODO: implement initialState
  SaveState get initialState => InitUser();

  @override
  Stream<SaveState> mapEventToState(SaveEvent event) async*{

    if(event is UpdateUser) {
      if(event.user.name.isEmpty) {
        yield NameMissing();
      }else {
        try {
          print('update user called');
          await _userRepo.updateRecord(event.user);
          yield SaveSuccess();
        }catch (ex) {
          yield SaveFail();
        }
      }
    }

    if(event is DeleteUser) {
        try {
          await _userRepo.deleteRecord(event.id);
          yield SaveSuccess();
        }catch (ex) {
          yield DeleteFail();
        }
    }
  }

}