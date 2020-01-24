import 'package:flutter/material.dart';
import 'package:flutter_101/models/list.dart';
import 'package:flutter_101/models/persistManager.dart';
import 'package:flutter_101/todoList.dart';

class ListManager extends StatefulWidget {
  static const routeName = '/';

  ListManager({Key key}) : super(key: key);

  @override
  _ListManagerState createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> {
  TODOListManager _listManager;

  initState() {
    super.initState();

    TODOListManager.load().then((lm) => setState(() {
          _listManager = lm;
        }));
  }

  _addList(String name) async {
    setState(() {
      _listManager.add(name);
    });
  }

  _navigateToList(int idx) => () {
        Navigator.pushNamed(context, TODOListWidget.routeName,
            arguments: _listManager.getList(idx));
      };

  _removeList(TODOList list) => (d) {
        setState(() {
          _listManager.remove(list.id);
        });
      };

  _showDialogAddList() {
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
                    labelText: 'Name this list', hintText: 'eg. Shopping list'),
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
                _addList(listName);
                _navigateToList(_listManager.length);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: _listManager?.length ?? 0,
          itemBuilder: (c, idx) {
            var list = _listManager.getList(idx);
            return Dismissible(
              key: Key(list.name),
              onDismissed: _removeList(list),
              direction: DismissDirection.endToStart,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: _navigateToList(idx),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(list.name,
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
        onPressed: _showDialogAddList,
        child: Icon(Icons.add),
      ),
    );
  }
}
