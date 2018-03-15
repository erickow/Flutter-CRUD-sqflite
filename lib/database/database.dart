import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/note.dart';

class DatabaseClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "notenitydb.db");

    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute(""" CREATE TABLE notification (
        id INTEGER AUTOINCREMENT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        assign BOOLEAN )""");

  }

  Future upsertNote(Note note) async {
    if (note.id == null) {
      note.id = await _db.insert("note", note.toMap());
    } else {
      await _db.update("note", note.toMap(), where: "id = ?", whereArgs: [note.id]);
    }

    return note;
  }

  Future fetchNote(int id) async {
    List results = await _db.query("note", columns: Note.columns, where: "id = ?", whereArgs: [id]);

    Note note = new Note.fromMap(results[0]);

    return note;
  }

  Future fetchAllNote() async {
    List results = await _db.query("note", columns: Note.columns, orderBy: "id DESC");
    Note note = new Note.fromMap(results[0]);
    return note;
  }

  Future<List> fetchLatestNotes(int limit) async {
    List results = await _db.query("note", columns: Note.columns, limit: limit, orderBy: "id DESC");

    List notes = new List();
    results.forEach((result) {
      Note note = new Note.fromMap(result);
      notes.add(note);
    });

    return notes;
  }
}