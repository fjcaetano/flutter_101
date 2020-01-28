import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';

class State {
  final Map<String, TODOList> lists;
  final bool hydrated;

  State({this.lists = const {}, this.hydrated = true});
}

// Reducers

State _addList(State state, AddListAction action) =>
    State(hydrated: state.hydrated, lists: {
      ...state.lists,
      action.list.id: action.list,
    });

State _removeList(State state, RemoveListAction action) =>
    State(lists: state.lists..remove(action.listId), hydrated: state.hydrated);

State _addTODO(State state, AddTODOAction action) =>
    State(hydrated: state.hydrated, lists: {
      ...state.lists,
      action.listId: state.lists[action.listId]..addTodo(action.todo),
    });

State _removeTODO(State state, RemoveTODOAction action) =>
    State(hydrated: state.hydrated, lists: {
      ...state.lists,
      action.listId: state.lists[action.listId]..removeTodo(action.idx),
    });

State _hydrate(State state, HydrateAction action) =>
    State(lists: action.lists, hydrated: true);

State _renameList(State state, RenameListAction action) => State(
    hydrated: state.hydrated,

    /// Waaaat? I know right?
    lists: state.lists..[action.listId].name = action.newName);

State _reorderList(State state, ReorderTODOListAction action) => State(
    hydrated: state.hydrated,
    lists: state.lists
      ..[action.listId].rearrangeTodo(action.oldIndex, action.newIndex));

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
