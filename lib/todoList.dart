import 'package:flutter/material.dart';
import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

class _TODOListViewModel {
  final Store<Reducers.State> store;
  final TODOList list;
  final String listId;

  _TODOListViewModel.converter(this.store, this.listId)
      : list = store.state.lists[listId];

  addTODO(String newName) {
    store.dispatch(AddTODOAction(listId: listId, todo: newName));
  }

  removeTODO(num idx) {
    store.dispatch(RemoveTODOAction(listId: listId, idx: idx));
  }

  rename(String newName) {
    store.dispatch(RenameListAction(listId: listId, newName: newName));
  }

  reorderTODO(num oldIdx, num newIdx) {
    store.dispatch(ReorderTODOListAction(
        listId: listId, oldIndex: oldIdx, newIndex: newIdx));
  }
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
        converter: (s) => _TODOListViewModel.converter(s, widget.listId),
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
              child: ReorderableListView(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                onReorder: vm.reorderTODO,
                children: <Widget>[
                  for (var i = 0; i < vm.list.length; i++)
                    Card(
                      key: Key(vm.list[i]),
                      elevation: 10,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: ListTile(
                        title: Text(vm.list[i],
                            style: Theme.of(context).textTheme.headline),
                        leading: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Icon(Icons.remove_circle, color: Colors.red),
                        ),
                        onTap: () => vm.removeTODO(i),
                      ),
                    ),
                ],
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
