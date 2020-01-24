import 'package:flutter/material.dart';
import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

class _TODOListViewModel {
  final TODOList list;
  final String Function(String name) addTODO;
  final void Function(num idx) removeTODO;
  final void Function(String newName) rename;

  _TODOListViewModel._({this.list, this.addTODO, this.removeTODO, this.rename});

  static converter(String listId) =>
      (Store<Reducers.State> store) => _TODOListViewModel._(
          list: store.state.lists[listId],
          addTODO: (n) =>
              store.dispatch(AddTODOAction(listId: listId, todo: n)),
          removeTODO: (i) =>
              store.dispatch(RemoveTODOAction(listId: listId, idx: i)),
          rename: (n) =>
              store.dispatch(RenameListAction(listId: listId, newName: n)));
}

class TODOListWidget extends StatefulWidget {
  static const routeName = '/todoList';

  final String listId;

  TODOListWidget({Key key, this.listId}) : super(key: key);

  @override
  _TODOListState createState() => _TODOListState();
}

class _TODOListState extends State<TODOListWidget> {
  _showNewTODODialog(_TODOListViewModel vm) {
    String newTODO;
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
                    labelText: 'What do you need to do?',
                    hintText: 'eg. Buy eggs'),
                onChanged: (name) {
                  newTODO = name;
                },
              ),
            )
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
                vm.addTODO(newTODO);
              })
        ],
      ),
    );
  }

  _showEditNameDialog(_TODOListViewModel vm) {
    String newName;
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
                    hintText: 'eg. ${vm.list.name}'),
                onChanged: (name) {
                  newName = name;
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.pop(context);
                vm.rename(newName);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<Reducers.State, _TODOListViewModel>(
        converter: _TODOListViewModel.converter(widget.listId),
        builder: (c, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text(vm.list.name),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => _showEditNameDialog(vm),
                    child: Icon(Icons.edit, color: Colors.white))
              ],
            ),
            body: Container(
              color: Colors.blueGrey,
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                itemCount: vm.list.length,
                itemBuilder: (context, int idx) => FlatButton(
                  onPressed: () => vm.removeTODO(idx),
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Icon(Icons.remove_circle, color: Colors.red),
                          ),
                          Text(vm.list.getTodo(idx),
                              style: Theme.of(context).textTheme.headline),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showNewTODODialog(vm),
              child: Icon(Icons.add),
            ),
          );
        });
  }
}
