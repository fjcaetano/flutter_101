import 'package:flutter_101/models/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StorageKeys {
  static final listIds = 'list_ids';
  static listName(String id) => 'list_$id.name';
  static listItems(String id) => 'list_$id.items';
}

extension TODOListPersist on TODOList {
  static _load(String id) async {
    var prefs = await SharedPreferences.getInstance();

    var name = prefs.getString(_StorageKeys.listName(id));
    var items = prefs.getStringList(_StorageKeys.listItems(id));

    return TODOList(id: id, name: name, todos: items);
  }

  static Future<List<TODOList>> loadLists() async {
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
