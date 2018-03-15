import 'package:notenity/model/note.dart';
import 'package:sqflite/sqflite.dart';
import '../src/common_import.dart';
import 'dart:convert';

final String tableNote = "note";
final String columnId = "id";
final String columnTitle = "title";
final String columnDescriptiom = "descriptiom";
final String columnAssign = "assign";



class NoteProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableNote ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDescriptiom text not null)
''');
        });
  }

  Future<Note> insert(Note note) async {
    note.id = await db.insert(tableNote, note.toMap());
    return note;
  }

  Future<List<Map>> getAllNote()async {
    List<Map> maps = await db.rawQuery('SELECT * FROM "table"');
    return maps;
  }

  Future<Note> getNote(int id) async {
    List<Map> maps = await db.query(tableNote,
        columns: [columnId, columnDescriptiom, columnTitle, columnAssign],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Note.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableNote, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    return await db.update(tableNote, note.toMap(),
        where: "$columnId = ?", whereArgs: [note.id]);
  }

  Future close() async => db.close();
}
