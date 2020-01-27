import 'package:flutter_101/models/list.dart';

enum Actions {
  LoadFromDisk,
  Hydrate,
  AddList,
  RemoveList,
  AddTODO,
  RemoveTODO,
  RenameList,
  ReorderTODOList,
}

class AddListAction {
  final type = Actions.AddList;
  final TODOList list;

  AddListAction({this.list});
}

class RemoveListAction {
  final type = Actions.RemoveList;
  final String listId;

  RemoveListAction({this.listId});
}

class AddTODOAction {
  final type = Actions.AddTODO;
  final String listId;
  final String todo;

  AddTODOAction({this.listId, this.todo});
}

class RemoveTODOAction {
  final type = Actions.RemoveTODO;
  final String listId;
  final num idx;

  RemoveTODOAction({this.listId, this.idx});
}

class LoadFromDiskAction {
  final type = Actions.LoadFromDisk;
}

class HydrateAction {
  final type = Actions.Hydrate;
  final Map<String, TODOList> lists;

  HydrateAction({this.lists});
}

class RenameListAction {
  final type = Actions.RenameList;
  final String listId;
  final String newName;

  RenameListAction({this.listId, this.newName});
}

class ReorderTODOListAction {
  final type = Actions.ReorderTODOList;
  final String listId;
  final int oldIndex;
  final int newIndex;

  ReorderTODOListAction({this.listId, this.oldIndex, this.newIndex});
}
