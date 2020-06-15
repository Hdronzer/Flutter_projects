
import 'package:equatable/equatable.dart';

abstract class SaveState  extends Equatable{
  const SaveState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SaveSuccess extends SaveState {}

class SaveFail extends SaveState{}

class NameMissing extends SaveState{}

class InitUser extends SaveState {}

class DeleteFail extends SaveState {}