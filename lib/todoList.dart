import 'package:flutter/material.dart';
import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

final createAnimController = (TickerProvider vsync) => AnimationController(
    duration: const Duration(milliseconds: 280), vsync: vsync);

class _TODOListViewModel {
  final Store<Reducers.State> store;
  final TODOList list;
  final List<AnimationController> animControllers;
  final TickerProvider vsync;

  _TODOListViewModel.converter(
      this.store, String listId, this.vsync, this.animControllers)
      : list = store.state.lists[listId];

  addTODO(String newName) {
    store.dispatch(AddTODOAction(listId: list.id, todo: newName));
    animControllers.add(createAnimController(vsync)..forward());
  }

  removeTODO(num idx) async {
    await animControllers.removeAt(idx).animateBack(0);
    store.dispatch(RemoveTODOAction(listId: list.id, idx: idx));
  }

  rename(String newName) {
    store.dispatch(RenameListAction(listId: list.id, newName: newName));
  }

  reorderTODO(num oldIdx, num newIdx) {
    store.dispatch(ReorderTODOListAction(
        listId: list.id, oldIndex: oldIdx, newIndex: newIdx));
  }
}

class TODOListWidget extends StatefulWidget {
  final String listId;

  TODOListWidget({Key key, this.listId}) : super(key: key);

  @override
  _TODOListState createState() => _TODOListState();
}

class _TODOListState extends State<TODOListWidget>
    with TickerProviderStateMixin {
  final List<AnimationController> animControllers = [];

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

  _buildItem(_TODOListViewModel vm, num i) => FadeTransition(
      key: Key(vm.list[i]),
      opacity: Tween<double>(begin: 0, end: 1).animate(animControllers[i]),
      child: Card(
        elevation: 10,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ListTile(
          title: Text(vm.list[i], style: Theme.of(context).textTheme.headline),
          leading: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Icon(Icons.remove_circle, color: Colors.red),
          ),
          onTap: () {
            vm.removeTODO(i);
          },
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return StoreConnector<Reducers.State, _TODOListViewModel>(
        converter: (s) => _TODOListViewModel.converter(
            s, widget.listId, this, animControllers),
        onInit: (store) {
          // Probably not the best approach ¯\_(ツ)_/¯
          animControllers.addAll([
            for (var i = 0; i < store.state.lists[widget.listId].length; i++)
              createAnimController(this)..value = 1
          ]);
        },
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
                  for (var i = 0; i < vm.list.length; i++) _buildItem(vm, i)
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
