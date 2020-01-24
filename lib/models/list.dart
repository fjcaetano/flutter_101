import 'package:flutter_101/models/persistManager.dart';

class TODOList {
  String id;
  String _name;
  List<String> _todos;

  TODOList({this.id, String name, List<String> todos}) {
    _name = name;
    _todos = todos ?? [];
  }

  String get name {
    return _name;
  }

  num get length {
    return _todos.length;
  }

  set name(String newName) {
    _name = newName;
    save();
  }

  String getTodo(int idx) => _todos[idx];

  addTodo(String todo) {
    _todos.add(todo);
    save();
  }

  removeTodo(int idx) {
    _todos.removeAt(idx);
    save();
  }
}
