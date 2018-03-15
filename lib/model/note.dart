import 'dart:convert';

class Note {
  Note();
  int id;
  String title;
  String description;
  bool assign;

  static final columns = ["id", "title", "description", "assign"];

  Map toMap() {
    Map map = {
      "title": title,
      "description": description,
      "assign": assign ? 1:0,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  Note.fromMap(Map map) {
    Note note = new Note();
    note.id = map["id"];
    note.title = map["title"];
    note.description = map["description"];
    note.assign = map["assign"];
  }
}