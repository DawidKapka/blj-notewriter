import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './navbar.dart';
import './single_note.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('My Notes'),
        ),
        body: Scrollbar(
            child: ListView(children: [
          ListTile(title: SingleNote()),
          CupertinoButton(
              child: Text('New Note'),
              color: Colors.blue,
              disabledColor: Colors.grey[400],
              onPressed: () {}
              ),
        ])));
  }
}
