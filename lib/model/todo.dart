// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'user.dart';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo extends ParseObject implements ParseCloneable {
  String objectId;
  String task;

  Todo({
    this.objectId,
    this.task,
  }) : super('Todo');

  Todo.clone() : this();

  @override
  Todo clone(Map<String, dynamic> map) => Todo.clone()..fromJson(map);

  @override
  Todo fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    if (objectData.containsKey('owner')) {
      owner = User.clone().fromJson(objectData['owner']);
    }
    return this;
  }

  DateTime get date => get<DateTime>('due_date');

  set date(DateTime date) => set<DateTime>('due_date', date);

  User get owner => get<User>('owner');

  set owner(User owner) => set<User>('owner', owner);

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        objectId: json["objectId"],
        task: json["task"],
      );
}
