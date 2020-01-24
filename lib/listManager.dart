import 'package:flutter/material.dart';
import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_101/todoList.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

class _ListManagerViewModel {
  final List<TODOList> lists;
  final TODOList Function(String name) addList;
  final void Function(TODOList list) removeList;

  _ListManagerViewModel({this.lists, this.addList, this.removeList});

  static _ListManagerViewModel converter(Store<Reducers.State> store) =>
      _ListManagerViewModel(
          lists: store.state.lists.values.toList(),
          addList: (l) {
            var list = TODOList(name: l);
            store.dispatch(AddListAction(list: list));
            return list;
          },
          removeList: (l) => store.dispatch(RemoveListAction(listId: l.id)));
}

class ListManager extends StatefulWidget {
  static const routeName = '/';

  ListManager({Key key}) : super(key: key);

  @override
  _ListManagerState createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> {
  _navigateToList(TODOList list) {
    Navigator.pushNamed(context, TODOListWidget.routeName, arguments: list.id);
  }

  _showDialogAddList(_ListManagerViewModel vm) => () {
        String listName;
        showDialog<String>(
          context: context,
          builder: (c) => AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Name this list',
                        hintText: 'eg. Shopping list'),
                    onChanged: (name) {
                      listName = name;
                    },
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('Add'),
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToList(vm.addList(listName));
                  })
            ],
          ),
        );
      };

  @override
  Widget build(BuildContext context) {
    return StoreConnector<Reducers.State, _ListManagerViewModel>(
        converter: _ListManagerViewModel.converter,
        builder: (c, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Lists'),
            ),
            body: Container(
              color: Colors.blueGrey,
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: vm.lists.length,
                itemBuilder: (c, idx) {
                  return Dismissible(
                    key: Key(vm.lists[idx].name),
                    onDismissed: (d) => vm.removeList(vm.lists[idx]),
                    direction: DismissDirection.endToStart,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () => _navigateToList(vm.lists[idx]),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Text(vm.lists[idx].name,
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.headline),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _showDialogAddList(vm),
              child: Icon(Icons.add),
            ),
          );
        });
  }
}
