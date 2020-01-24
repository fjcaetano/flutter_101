import 'dart:math';

import 'package:flutter_101/models/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StorageKeys {
  static final listIds = 'list_ids';
  static final nextId = 'next_id';
  static listName(String id) => 'list_$id.name';
  static listItems(String id) => 'list_$id.items';
}

class TODOListManager {
  static var _idCounter = 0;
  List<TODOList> _lists;

  TODOListManager._();

  static load() async {
    _idCounter = await SharedPreferences.getInstance()
        .then((p) => p.getInt(_StorageKeys.nextId) ?? 0);
    var result = TODOListManager._();
    result._lists = await TODOListPersist._loadLists();
    return result;
  }

  num get length {
    return _lists.length;
  }

  TODOList getList(int idx) => _lists[idx];

  void add(String name) {
    final list =
        TODOList(id: (TODOListManager._idCounter++).toString(), name: name);
    _lists.add(list);
    list.save();
    _saveIds();
  }

  void remove(String id) {
    _lists.removeWhere((l) => l.id == id);
    _saveIds();
  }

  _saveIds() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_StorageKeys.listIds, _lists.map((l) => l.id).toList());
    prefs.setInt(_StorageKeys.nextId, _idCounter);
  }
}

extension TODOListPersist on TODOList {
  static _load(String id) async {
    var prefs = await SharedPreferences.getInstance();

    var name = prefs.getString(_StorageKeys.listName(id));
    var items = prefs.getStringList(_StorageKeys.listItems(id));

    return TODOList(id: id, name: name, todos: items);
  }

  static _loadLists() async {
    var prefs = await SharedPreferences.getInstance();
    final result = <TODOList>[];

    for (var id in prefs.getStringList(_StorageKeys.listIds) ?? []) {
      result.add(await _load(id));
    }

    return result;
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_StorageKeys.listName(id), name);
    prefs.setStringList(_StorageKeys.listItems(id),
        [for (var i = 0; i < length; i++) getTodo(i)]);
  }
}
