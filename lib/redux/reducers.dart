import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:redux/redux.dart';

import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';

class State {
  final Map<String, TODOList> lists;
  bool hydrated;
  bool isScanningBeacons;
  final List<String> routes;
  final Map<String, Beacon> foundBeacons;

  State clone() => State.fromState(this);

  State(
      {this.lists = const {},
      this.hydrated = true,
      this.routes,
      this.isScanningBeacons = false,
      this.foundBeacons});

  State.fromState(State state)
      : this(
            lists: {...state.lists},
            hydrated: state.hydrated,
            routes: state.routes,
            isScanningBeacons: state.isScanningBeacons,
            foundBeacons: state.foundBeacons);
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

State _hydrate(State state, HydrateAction action) => State(
    lists: action.lists,
    hydrated: true,
    routes: state.routes,
    isScanningBeacons: state.isScanningBeacons,
    foundBeacons: state.foundBeacons);

State _renameList(State state, RenameListAction action) =>
    state.clone()..lists[action.listId].name = action.newName;

State _reorderList(State state, ReorderTODOListAction action) => state.clone()
  ..lists[action.listId].rearrangeTodo(action.oldIndex, action.newIndex);

State _navigateReplace(State state, NavigateReplaceAction action) => State(
    lists: state.lists,
    hydrated: state.hydrated,
    routes: [action.routeName],
    isScanningBeacons: state.isScanningBeacons);

State _navigatePush(State state, NavigatePushAction action) =>
    state.clone()..routes.add(action.routeName);

State _navigatePop(State state, NavigatePopAction action) =>
    state.clone()..routes.removeLast();

State _beaconsScannerActive(State state, _) =>
    state.clone()..isScanningBeacons = true;

State _stopScanningBeacons(State state, _) =>
    state.clone()..isScanningBeacons = false;

State _foundBeacon(State state, DidFoundBeaconAction action) => state.clone()
  ..foundBeacons.addEntries(
      action.result.beacons.map((b) => MapEntry(b.proximityUUID, b)));

State _discardBeacons(State state, _) => state.clone()..foundBeacons.clear();

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
  TypedReducer<State, StartScanningBeconsAction>(_beaconsScannerActive),
  TypedReducer<State, StopScanningBeaconsAction>(_stopScanningBeacons),
  TypedReducer<State, DidFoundBeaconAction>(_foundBeacon),
  TypedReducer<State, DiscardBeaconsResultAction>(_discardBeacons),
]);
