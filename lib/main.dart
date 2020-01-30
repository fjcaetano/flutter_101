import 'package:flutter/material.dart';
import 'package:flutter_101/listManager.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/middlewares/nfc.dart';
import 'package:flutter_101/redux/middlewares/persist.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_101/todoList.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _store = new Store(Reducers.reducer,
      initialState: Reducers.State(hydrated: false),
      middleware: [...createPersistMiddleware(), ...createNFCMiddleware()]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _store.dispatch(LoadFromDiskAction());
    _store.dispatch(StartNFCWatcherAction());
    return StoreProvider(
        store: _store,
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            onGenerateRoute: (settings) => MaterialPageRoute(builder: (c) {
                  switch (settings.name) {
                    case ListManager.routeName:
                      return ListManager();

                    case TODOListWidget.routeName:
                      return TODOListWidget(listId: settings.arguments);
                  }

                  return null;
                })));
  }
}
