import 'package:flutter/material.dart';
import 'package:flutter_101/listManager.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_101/todoList.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _store = new Store(Reducers.reducer,
      initialState: Reducers.State(hydrated: false),
      middleware: [Reducers.InitMiddleware()]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _store.dispatch(LoadFromDiskAction());
    return StoreProvider(
        store: _store,
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
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
