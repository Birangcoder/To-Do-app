import 'package:flutter/cupertino.dart';

import '../helper/db_helper.dart';
import '../model/to_do.dart';

class ToDoProvider extends ChangeNotifier {
  final DBHelper dbRef = DBHelper();
  List<ToDo> _toDo = [];

  List<ToDo> get toDo => _toDo;
  bool isLoading = true;

  Future<void> getNotes() async {
    isLoading = true;
    notifyListeners();

    _toDo = await dbRef.getAllNotes();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(String item) async {
    await dbRef.addNote(todo: ToDo(title: item, isDone: false));
    await getNotes();
  }

  Future<void> editItem(index, item, isDone) async {
    await dbRef.updateNote(
      todo: ToDo(id: index, title: item, isDone: isDone),
    );
    await getNotes();
  }

  Future<void> deleteItem(index) async {
    await dbRef.deleteNote(sNo: index);
    await getNotes();
  }
}
