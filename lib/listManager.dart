import 'package:flutter/material.dart';
import 'package:flutter_101/models/appRoutes.dart';
import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

class _ListManagerViewModel {
  final Store<Reducers.State> store;
  final List<TODOList> lists;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  _ListManagerViewModel.converter(this.store)
      : lists = store.state.lists.values.toList();

  addList(String name) {
    var list = TODOList(name: name);
    store.dispatch(AddListAction(list: list));
    listKey.currentState.insertItem(lists.length);
    return list;
  }

  removeList(TODOList list) {
    final idx = lists.indexOf(list);
    listKey.currentState.removeItem(idx, (c, a) => null);
    store.dispatch(RemoveListAction(listId: list.id));
  }

  void navigateToTODO(String listId) {
    store.dispatch(
        NavigatePushAction(routeName: AppRoutes.todo, arguments: listId));
  }
}

class ListManager extends StatefulWidget {
  ListManager({Key key}) : super(key: key);

  @override
  _ListManagerState createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> {
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
                    vm.addList(listName);
                  })
            ],
          ),
        );
      };

  @override
  Widget build(BuildContext context) {
    return StoreConnector<Reducers.State, _ListManagerViewModel>(
        converter: (s) => _ListManagerViewModel.converter(s),
        onWillChange: (prevVM, newVM) {
          if (prevVM.lists.length == 0) {
            // hydrate the animation state
            for (var i = 0; i < newVM.lists.length; i++) {
              prevVM.listKey.currentState.insertItem(i);
            }
          }
        },
        builder: (c, vm) => Scaffold(
              appBar: AppBar(
                title: Text('My Lists'),
              ),
              body: Container(
                color: Colors.blueGrey,
                child: AnimatedList(
                  key: vm.listKey,
                  padding: EdgeInsets.all(20),
                  initialItemCount: vm.lists.length, // 0
                  itemBuilder: (c, idx, a) => FadeTransition(
                    key: Key(vm.lists[idx].name),
                    opacity: a,
                    child: Dismissible(
                      key: Key(vm.lists[idx].name),
                      onDismissed: (d) => vm.removeList(vm.lists[idx]),
                      direction: DismissDirection.endToStart,
                      child: Card(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: ListTile(
                          onTap: () => vm.navigateToTODO(vm.lists[idx].id),
                          title: Text(vm.lists[idx].name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _showDialogAddList(vm),
                child: Icon(Icons.add),
              ),
            ));
  }
}
