import 'package:uuid/uuid.dart';

class TODOList {
  String id;
  String name;
  List<String> _todos;

  TODOList({String id, this.name, List<String> todos}) {
    _todos = todos ?? [];
    this.id = id ?? Uuid().v4();
  }

  num get length {
    return _todos.length;
  }

  String getTodo(int idx) => _todos[idx];

  addTodo(String todo) {
    _todos.add(todo);
  }

  removeTodo(int idx) {
    _todos.removeAt(idx);
  }

  rearrangeTodo(int oldIndex, int newIndex) {
    String todo = _todos.removeAt(oldIndex);
    if (newIndex <= _todos.length) {
      _todos.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, todo);
    } else {
      _todos.add(todo);
    }
  }
}
