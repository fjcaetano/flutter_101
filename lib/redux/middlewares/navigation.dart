import 'package:flutter/material.dart';
import 'package:flutter_101/main.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:redux/redux.dart';

import 'package:flutter_101/redux/actions.dart';

List<Middleware<Reducers.State>> createNavigationMiddleware() => [
      TypedMiddleware<Reducers.State, NavigateReplaceAction>(_navigateReplace),
      TypedMiddleware<Reducers.State, NavigatePushAction>(_navigate),
    ];

_navigateReplace(Store<Reducers.State> store, NavigateReplaceAction action,
    NextDispatcher next) {
  if (store.state.routes.last != action.routeName) {
    navigatorKey.currentState.pushReplacementNamed(action.routeName);
  }

  next(action); //This need to be after name checks
}

_navigate(Store<Reducers.State> store, NavigatePushAction action,
    NextDispatcher next) {
  if (store.state.routes.last != action.routeName) {
    navigatorKey.currentState
        .pushNamed(action.routeName, arguments: action.arguments);
    next(action); //This need to be after name checks
  }
}

class NavigationObserver extends NavigatorObserver {
  final Store<dynamic> store;

  NavigationObserver({this.store}) : assert(store != null);

  @override
  void didPop(Route route, Route previousRoute) {
    store.dispatch(NavigatePopAction());
  }
}
