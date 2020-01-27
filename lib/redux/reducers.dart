import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/models/persistManager.dart';
import 'package:flutter_101/redux/actions.dart';

import 'package:redux/redux.dart';

class State {
  final Map<String, TODOList> lists;
  final bool hydrated;

  State({this.lists = const {}, this.hydrated = true});
}

// Reducers

State _addList(State state, AddListAction action) => State(lists: {
      ...state.lists,
      action.list.id: action.list,
    });

State _removeList(State state, RemoveListAction action) {
  state.lists.remove(action.listId);
  return state;
}

State _addTODO(State state, AddTODOAction action) {
  var list = state.lists[action.listId];
  list.addTodo(action.todo);
  return state;
}

State _removeTODO(State state, RemoveTODOAction action) {
  var list = state.lists[action.listId];
  list.removeTodo(action.idx);
  return state;
}

State _hydrate(State state, HydrateAction action) {
  return State(lists: action.lists, hydrated: true);
}

State _renameList(State state, RenameListAction action) {
  TODOList list = state.lists[action.listId];
  list.name = action.newName;
  return state;
}

State _reorderList(State state, ReorderTODOListAction action) {
  TODOList list = state.lists[action.listId];
  list.rearrangeTodo(action.oldIndex, action.newIndex);
  return state;
}

/// Reducer

State reducer(State state, dynamic action) {
  switch (action.type) {
    case Actions.AddList:
      return _addList(state, action);

    case Actions.RemoveList:
      return _removeList(state, action);

    case Actions.AddTODO:
      return _addTODO(state, action);

    case Actions.RemoveTODO:
      return _removeTODO(state, action);

    case Actions.Hydrate:
      return _hydrate(state, action);

    case Actions.RenameList:
      return _renameList(state, action);

    case Actions.ReorderTODOList:
      return _reorderList(state, action);
  }

  return state;
}

class InitMiddleware implements MiddlewareClass<State> {
  @override
  dynamic call(Store<State> store, action, next) async {
    if (action.type == Actions.LoadFromDisk && !store.state.hydrated) {
      final lists = await TODOListPersist.loadLists();
      return next(HydrateAction(
          lists: Map.fromEntries(lists.map((l) => MapEntry(l.id, l)))));
    }

    next(action);
  }
}
