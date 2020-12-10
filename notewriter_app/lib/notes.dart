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
  @override
  Future<void> _nameNote(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              actions: [
                CupertinoButton(
                    child: Icon(Icons.done),
                    onPressed: () {
                      setState(() {
                        _notes.add(Text(nameController.text));
                        Navigator.of(context).pop();
                      });
                    })
              ],
              title: Text('Name: '),
              content: CupertinoTextField(
                  autocorrect: true,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(8))));
        });
  }

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
                    _nameNote(context);
                  })),
          NotesList(_notes, nameController.text),
          _isNotesEmpty(context)
        ])));
  }
}
