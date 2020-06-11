
import 'package:json_annotation/json_annotation.dart';

//@JsonSerializable()
class ToDoModel {
  int id;
  String title;
  bool completed;

  ToDoModel({this.id, this.title, this.completed});

  factory ToDoModel.fromJson(Map<String, dynamic> json) {
    return ToDoModel(
      id: json["id"],
      title: json["title"],
      completed: json["completed"]);
  }
 // Map<String, dynamic> toJson() => _$ToDoModelToJson(this);
}

class ToDoList {
  List<ToDoModel> list;

  ToDoList({this.list});

  factory ToDoList.fromJson(List<dynamic> json) {
    return ToDoList(
        list: json
            .map((e) => ToDoModel.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}