import 'package:flutter/material.dart';
import 'package:flutter_101/models/list.dart';

class Props {
  TODOList list;
}

class TODOListWidget extends StatefulWidget {
  static const routeName = '/todoList';

  final TODOList list;

  TODOListWidget({Key key, this.list}) : super(key: key);

  @override
  _TODOListState createState() => _TODOListState();
}

class _TODOListState extends State<TODOListWidget> {
  _addTODO(String name) {
    setState(() {
      widget.list.addTodo(name);
    });
  }

  _doTODO(int idx) => () {
        setState(() {
          widget.list.removeTodo(idx);
        });
      };

  _editName(String newName) {
    setState(() {
      widget.list.name = newName;
    });
  }

  _showNewTODODialog() {
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
                _addTODO(newTODO);
              })
        ],
      ),
    );
  }

  _showEditNameDialog() {
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
                    hintText: 'eg. ${widget.list.name}'),
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
                _editName(newName);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name),
        actions: <Widget>[
          FlatButton(
              onPressed: _showEditNameDialog,
              child: Icon(Icons.edit, color: Colors.white))
        ],
      ),
      body: Container(
        color: Colors.blueGrey,
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          itemCount: widget.list.length,
          itemBuilder: (context, int idx) => FlatButton(
            onPressed: _doTODO(idx),
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
                    Text(widget.list.getTodo(idx),
                        style: Theme.of(context).textTheme.headline),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewTODODialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
