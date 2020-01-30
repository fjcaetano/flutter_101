import 'package:redux/redux.dart';

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
    State(lists: {...state.lists}, hydrated: state.hydrated)
      ..lists.remove(action.listId);

State _addTODO(State state, AddTODOAction action) =>
    State(hydrated: state.hydrated, lists: {
      ...state.lists,
    })
      ..lists[action.listId].addTodo(action.todo);

State _removeTODO(State state, RemoveTODOAction action) =>
    State(hydrated: state.hydrated, lists: {
      ...state.lists,
    })
      ..lists[action.listId].removeTodo(action.idx);

State _hydrate(State state, HydrateAction action) =>
    State(lists: action.lists, hydrated: true);

State _renameList(State state, RenameListAction action) =>
    State(hydrated: state.hydrated, lists: {...state.lists})
      ..lists[action.listId].name = action.newName;

State _reorderList(State state, ReorderTODOListAction action) =>
    State(hydrated: state.hydrated, lists: {...state.lists})
      ..lists[action.listId].rearrangeTodo(action.oldIndex, action.newIndex);

/// Reducer

final reducer = combineReducers<State>([
  TypedReducer<State, AddListAction>(_addList),
  TypedReducer<State, RemoveListAction>(_removeList),
  TypedReducer<State, AddTODOAction>(_addTODO),
  TypedReducer<State, RemoveTODOAction>(_removeTODO),
  TypedReducer<State, HydrateAction>(_hydrate),
  TypedReducer<State, RenameListAction>(_renameList),
  TypedReducer<State, ReorderTODOListAction>(_reorderList),
]);
