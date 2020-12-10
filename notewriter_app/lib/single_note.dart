import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:notewriter_app/note_editor.dart';

class SingleNote extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Editor()));
            },
            child: Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightBlue[200],
                    border: Border.all(width: 2.0, color: Colors.blue[200])),
                child: Text('New Note', style: TextStyle(
                  fontWeight: FontWeight.bold
                )))));
  }
}
