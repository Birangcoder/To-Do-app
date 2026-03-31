import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/to_do.dart';

class DBHelper {
  // DBHelper._();

  // static final DBHelper getInstance = DBHelper._();
  final String TABLE_NOTE = "note";
  final String COLUMN_NOTE_SNO = "s_no";
  final String COLUMN_NOTE_TITLE = "title";
  final String COLUMN_NOTE_isDone = "isDone";

  static Database? _myDB;

  /// db Open (path -> if exits then open else create db)

  Future<Database> getDB() async {
    if (_myDB != null) {
      return _myDB!;
    } else {
      _myDB = await openDB();
      return _myDB!;
    }
  }

  Future<Database> openDB() async {
    String appDir = await getDatabasesPath();
    String dbPath = join(appDir, "noteDB.db");
    return await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        /// create all your tables here
        await db.execute(
          "create table IF NOT EXISTS $TABLE_NOTE ( $COLUMN_NOTE_SNO integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_isDone integer)",
        );

        /// another tables here
        /// another tables here
        /// another tables here
        /// another tables here
      },
      version: 1,
    );
  }

  /// all queries
  /// insertion
  Future<bool> addNote({required ToDo todo}) async {
    var db = await getDB();
    int rowAffected = await db.insert(TABLE_NOTE, todo.toMap());
    return rowAffected > 0;
  }

  /// read all data
  Future<List<ToDo>> getAllNotes() async {
    var db = await getDB();

    ///select * from note
    List<Map<String, dynamic>> data = await db.query(TABLE_NOTE);
    List<ToDo> mData = [];
    for (var e in data) {
      mData.add(ToDo.fromMap(e));
    }
    return mData;
  }

  /// update
  Future<bool> updateNote({required ToDo todo}) async {
    var db = await getDB();
    int rowAffected = await db.update(
      TABLE_NOTE,
      todo.toMap(),
      where: '$COLUMN_NOTE_SNO=${todo.id.toString()}',
    );
    return rowAffected > 0;
  }

  /// delete
  Future<bool> deleteNote({required int sNo}) async {
    var db = await getDB();
    int rowAffected = await db.delete(
      TABLE_NOTE,
      where: '$COLUMN_NOTE_SNO=${sNo.toString()}',
    );
    return rowAffected > 0;
  }
}
