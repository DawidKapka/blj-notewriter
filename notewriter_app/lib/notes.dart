import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notewriter_app/notes_list.dart';

import './navbar.dart';
import './single_note.dart';
import './main.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Widget> _notes = [];
  TextEditingController nameController = new TextEditingController();
  String title;
  @override

  Center _isNotesEmpty(BuildContext context) {
    if (_notes.length == 0) {
      return Center(child: Text("It's pretty empty in here..."));
    } else {
      return Center(child: Text(''));
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('My Notes'),
        ),
        drawer: NavBar(),
        body: Scrollbar(
            child: ListView(children: [
          Container(
              margin: EdgeInsets.all(8.0),
              child: CupertinoButton(
                  padding: EdgeInsets.all(20.0),
                  child: Text('New Note'),
                  color: Colors.blue,
                  disabledColor: Colors.grey[400],
                  onPressed: () {
                      setState(() {
                        _notes.add(Text(nameController.text));
                        title = _notes.toString();
                        Navigator.of(context).pop();
                      });
                  })),
          NotesList(_notes),
          _isNotesEmpty(context)
        ])));
  }
}
