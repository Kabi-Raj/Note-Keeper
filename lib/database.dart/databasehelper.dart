import 'package:note_keeper/model/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  static final tableName = 'Notes';
  static final id = 'id';
  static final title = 'title';
  static final description = 'description';
  static final date = 'date';
  static final priority = 'priority';

  DatabaseHelper._instance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._instance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print('path: ' + directory.path + '/notes.db');
    var path = directory.path + '/notes.db';
    return await openDatabase(path, version: 1, onCreate: _onCreate);

    //return _database;
  }

  Future _onCreate(Database db, int version) {
    Future result = db.execute(
        'CREATE TABLE $tableName ($id TEXT PRIMARY KEY,$title TEXT,$description TEXT,$date TEXT,$priority TEXT)');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    print(note.toMap());
    //return await db.rawInsert(
    //  'INSERT INTO $tableName VALUES($id=${note.id},$title=${note.title},$description=${note.date},$priority=${note.priority})');
    Future<int> result = db.insert('$tableName', note.toMap());
    //db.close();
    return result;
  }

  Future<int> deleteNote(String noteId) async {
    Database db = await this.database;
    return db.delete('$tableName', where: '$id=?', whereArgs: [noteId]);
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    return await db.update('$tableName', note.toMap(),
        where: '$id=?', whereArgs: [note.id]);
  }

  Future<List<Map<String, dynamic>>> getNote() async {
    Database db = await this.database;
    return await db.rawQuery('SELECT * FROM $tableName order by $date ASC');
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result);
    return count;
  }

  Future<List<Note>> fetchNotes() async {
    List<Note> noteList = List<Note>();
    int count = await getCount();
    List<Map<String, dynamic>> mapList = await getNote();
    if (mapList != null) {
      for (int i = 0; i < count; i++) {
        noteList.add(Note.fromMap(mapList[i]));
      }
    }
    return noteList;
  }
}
