import 'package:redux/redux.dart';

import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';

class State {
  final Map<String, TODOList> lists;
  bool hydrated;
  final List<String> routes;

  State clone() => State.fromState(this);

  State({this.lists = const {}, this.hydrated = true, this.routes});
  State.fromState(State state)
      : this(
            lists: {...state.lists},
            hydrated: state.hydrated,
            routes: state.routes);
}

// Reducers

State _addList(State state, AddListAction action) =>
    State.fromState(state)..lists[action.list.id] = action.list;

State _removeList(State state, RemoveListAction action) =>
    state.clone()..lists.remove(action.listId);

State _addTODO(State state, AddTODOAction action) =>
    state.clone()..lists[action.listId].addTodo(action.todo);

State _removeTODO(State state, RemoveTODOAction action) =>
    state.clone()..lists[action.listId].removeTodo(action.idx);

State _hydrate(State state, HydrateAction action) =>
    State(lists: action.lists, hydrated: true, routes: state.routes);

State _renameList(State state, RenameListAction action) =>
    state.clone()..lists[action.listId].name = action.newName;

State _reorderList(State state, ReorderTODOListAction action) => state.clone()
  ..lists[action.listId].rearrangeTodo(action.oldIndex, action.newIndex);

State _navigateReplace(State state, NavigateReplaceAction action) => State(
    lists: state.lists, hydrated: state.hydrated, routes: [action.routeName]);

State _navigatePush(State state, NavigatePushAction action) =>
    state.clone()..routes.add(action.routeName);

State _navigatePop(State state, NavigatePopAction action) =>
    state.clone()..routes.removeLast();

/// Reducer

final reducer = combineReducers<State>([
  TypedReducer<State, AddListAction>(_addList),
  TypedReducer<State, RemoveListAction>(_removeList),
  TypedReducer<State, AddTODOAction>(_addTODO),
  TypedReducer<State, RemoveTODOAction>(_removeTODO),
  TypedReducer<State, HydrateAction>(_hydrate),
  TypedReducer<State, RenameListAction>(_renameList),
  TypedReducer<State, ReorderTODOListAction>(_reorderList),
  TypedReducer<State, NavigateReplaceAction>(_navigateReplace),
  TypedReducer<State, NavigatePushAction>(_navigatePush),
  TypedReducer<State, NavigatePopAction>(_navigatePop),
]);
