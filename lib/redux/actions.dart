import 'package:flutter_101/models/list.dart';

abstract class ListIdAction {
  final String listId;

  ListIdAction({this.listId});
}

class ListAction {
  final TODOList list;

  ListAction({this.list});
}

class AddListAction extends ListAction {
  AddListAction({TODOList list}) : super(list: list);
}

class RemoveListAction {
  final String listId;

  RemoveListAction({this.listId});
}

class AddTODOAction extends ListIdAction {
  final String todo;

  AddTODOAction({String listId, this.todo}) : super(listId: listId);
}

class RemoveTODOAction extends ListIdAction {
  final num idx;

  RemoveTODOAction({String listId, this.idx}) : super(listId: listId);
}

class LoadFromDiskAction {}

class HydrateAction {
  final Map<String, TODOList> lists;

  HydrateAction({this.lists});
}

class RenameListAction extends ListIdAction {
  final String newName;

  RenameListAction({String listId, this.newName}) : super(listId: listId);
}

class ReorderTODOListAction extends ListIdAction {
  final int oldIndex;
  final int newIndex;

  ReorderTODOListAction({String listId, this.oldIndex, this.newIndex})
      : super(listId: listId);
}
