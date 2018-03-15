import 'package:flutter/material.dart';
import 'src/common_import.dart';
import 'package:notenity/database/database.dart';
import 'package:notenity/controller/noteController.dart';
import 'package:notenity/model/note.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Notenity - Home',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final formKey = new GlobalKey<FormState>();
  String _title;
  String _description;
  bool _assign;
  int number;
  List listNotes;

  DatabaseClient _db = new DatabaseClient();
  NoteProvider noteProvider = new NoteProvider();


  createdb() async {
    await noteProvider.open("notenity").then(
            (data) {
          noteProvider.getAllNote().then((list) {
            this.number = list[0][0]['COUNT(*)']; //3
            this.listNotes = list;
            //[{name: foo1, color: 0}, {name: foo2, color: 1}, {name: foo3, color: 2}]
          });
        }
    );
  }

  void showFormDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
        .then<Null>((T value) {
      if (value != null) {
        setState(() {
          print(value);
        });
      }
    });
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _addData();
    }
  }

  void _addData() {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text('data title: $_title, desc: $_description berhasil ditambahkan'),
    );
    Note note = new Note();
    note.title = '$_title';
    note.description = '$_description';
    note.assign = false;
    noteProvider.insert(note);


    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: null),
        ],
      ),
      body: _buildSuggestions(),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: () {
          showFormDialog(
              context: context,
              child: new SimpleDialog(
                title: const Text('Tambah Note'),
                children: <Widget>[
                  new Form(
                    key: formKey,
                    child: new Column(
                      children: [
                        new TextFormField(
                          decoration: new InputDecoration(labelText: 'Title'),
                          validator: (val) =>
                          val.isEmpty ? 'Title can\'t be null.' : null,
                          onSaved: (val) => _title = val,
                        ),
                        new TextFormField(
                          decoration: new InputDecoration(labelText: 'Description'),
                          validator: (val) =>
                          val.isEmpty ? 'Description can\'t be null' : null,
                          onSaved: (val) => _description = val,
                        ),
                        new RaisedButton(
                          onPressed: _submit,
                          child: new Text('submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    String ini_string = "ini string";
    if(!this.listNotes[1]==null){
     ini_string = 'iniapa';
    }
    return new Text(ini_string, style: _biggerFont,);
  }




}
