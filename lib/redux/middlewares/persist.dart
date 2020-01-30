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

List<Middleware<State>> createPersistMiddleware() => [
      TypedMiddleware<State, LoadFromDiskAction>(_loadFromDisk),
      TypedMiddleware<State, RemoveListAction>(_removeList),
      TypedMiddleware<State, AddListAction>(_saveList),
      TypedMiddleware<State, AddTODOAction>(_saveListFromId),
      TypedMiddleware<State, RemoveTODOAction>(_saveListFromId),
      TypedMiddleware<State, RenameListAction>(_saveListFromId),
      TypedMiddleware<State, ReorderTODOListAction>(_saveListFromId),
    ];

void _loadFromDisk(Store<State> store, _, NextDispatcher next) async {
  var prefs = await SharedPreferences.getInstance();
  final result = <TODOList>[];

  for (var id in prefs.getStringList(_StorageKeys.listIds) ?? []) {
    result.add(await _load(id));
  }

  next(HydrateAction(
      lists: Map.fromEntries(result.map((l) => MapEntry(l.id, l)))));
}

void _removeList(
    Store<State> store, RemoveListAction action, NextDispatcher next) async {
  var prefs = await SharedPreferences.getInstance();
  final idList =
      Set<String>.from(prefs.getStringList(_StorageKeys.listIds) ?? []);
  idList.remove(action.listId);

  await Future.wait([
    prefs.setStringList(_StorageKeys.listIds, idList.toList()),
    prefs.remove(_StorageKeys.listItems(action.listId)),
    prefs.remove(_StorageKeys.listName(action.listId)),
  ]);

  next(action);
}

void _saveListFromId(
    Store<State> store, ListIdAction action, NextDispatcher next) {
  final list = store.state.lists[action.listId];
  _saveList(store, ListAction(list: list), null);

  next(action);
}

void _saveList(
    Store<State> store, ListAction action, NextDispatcher next) async {
  var prefs = await SharedPreferences.getInstance();
  final idList =
      Set<String>.from(prefs.getStringList(_StorageKeys.listIds) ?? []);
  idList.add(action.list.id);

  await Future.wait([
    prefs.setString(_StorageKeys.listName(action.list.id), action.list.name),
    prefs.setStringList(_StorageKeys.listItems(action.list.id),
        [for (var i = 0; i < action.list.length; i++) action.list[i]]),
    prefs.setStringList(_StorageKeys.listIds, idList.toList())
  ]);

  if (next != null) {
    next(action);
  }
}

Future<TODOList> _load(String id) async {
  var prefs = await SharedPreferences.getInstance();

  var name = prefs.getString(_StorageKeys.listName(id));
  var items = prefs.getStringList(_StorageKeys.listItems(id));

  return TODOList(id: id, name: name, todos: items);
}
