import 'package:flutter_101/models/persistManager.dart';
import 'package:uuid/uuid.dart';

class TODOList {
  String id;
  String _name;
  List<String> _todos;

  TODOList({String id, String name, List<String> todos}) {
    _name = name;
    _todos = todos ?? [];
    this.id = id ?? Uuid().v4();
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
