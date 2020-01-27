import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart';
import 'package:redux/redux.dart';

import 'package:flutter_101/models/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StorageKeys {
  static final listIds = 'list_ids';
  static listName(String id) => 'list_$id.name';
  static listItems(String id) => 'list_$id.items';
}

class PersistReduxMiddleware implements MiddlewareClass<State> {
  @override
  dynamic call(Store<State> store, action, next) async {
    switch (action.type) {
      case Actions.LoadFromDisk:
        final lists = await _loadLists();
        return next(HydrateAction(
            lists: Map.fromEntries(lists.map((l) => MapEntry(l.id, l)))));

      case Actions.RemoveList:
        _removeList(action.listId);
        break;

      case Actions.AddList:
        _saveList(action.list);
        break;

      case Actions.AddTODO:
      case Actions.RemoveTODO:
      case Actions.RenameList:
      case Actions.ReorderTODOList:
        final list = store.state.lists[action.listId];
        _saveList(list);
        break;
    }

    next(action);
  }

  /// Private Methods

  _removeList(String id) async {
    var prefs = await SharedPreferences.getInstance();
    final idList =
        Set<String>.from(prefs.getStringList(_StorageKeys.listIds) ?? []);
    idList.remove(id);

    await Future.wait([
      prefs.setStringList(_StorageKeys.listIds, idList.toList()),
      prefs.remove(_StorageKeys.listItems(id)),
      prefs.remove(_StorageKeys.listName(id)),
    ]);
  }

  _load(String id) async {
    var prefs = await SharedPreferences.getInstance();

    var name = prefs.getString(_StorageKeys.listName(id));
    var items = prefs.getStringList(_StorageKeys.listItems(id));

    return TODOList(id: id, name: name, todos: items);
  }

  Future<List<TODOList>> _loadLists() async {
    var prefs = await SharedPreferences.getInstance();
    final result = <TODOList>[];

    for (var id in prefs.getStringList(_StorageKeys.listIds) ?? []) {
      result.add(await _load(id));
    }

    return result;
  }

  _saveList(TODOList list) async {
    var prefs = await SharedPreferences.getInstance();
    final idList =
        Set<String>.from(prefs.getStringList(_StorageKeys.listIds) ?? []);
    idList.add(list.id);

    await Future.wait([
      prefs.setString(_StorageKeys.listName(list.id), list.name),
      prefs.setStringList(_StorageKeys.listItems(list.id),
          [for (var i = 0; i < list.length; i++) list.getTodo(i)]),
      prefs.setStringList(_StorageKeys.listIds, idList.toList())
    ]);
  }
}
