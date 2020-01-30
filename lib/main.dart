import 'package:flutter/material.dart';
import 'package:flutter_101/listManager.dart';
import 'package:flutter_101/models/appRoutes.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/middlewares/navigation.dart';
import 'package:flutter_101/redux/middlewares/nfc.dart';
import 'package:flutter_101/redux/middlewares/persist.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_101/todoList.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

void main() => runApp(MyApp());
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final _store = new Store(Reducers.reducer,
      initialState: Reducers.State(hydrated: false, routes: [AppRoutes.home]),
      middleware: [
        ...createPersistMiddleware(),
        ...createNFCMiddleware(),
        ...createNavigationMiddleware()
      ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _store.dispatch(LoadFromDiskAction());
    _store.dispatch(StartNFCWatcherAction());
    return StoreProvider(
        store: _store,
        child: MaterialApp(
            title: 'Flutter Demo',
            navigatorKey: navigatorKey,
            navigatorObservers: [NavigationObserver(store: _store)],
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            onGenerateRoute: (settings) => MaterialPageRoute(builder: (c) {
                  switch (settings.name) {
                    case AppRoutes.home:
                      return ListManager();

                    case AppRoutes.todo:
                      return TODOListWidget(listId: settings.arguments);
                  }

                  return null;
                })));
  }
}
