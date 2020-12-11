import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './navbar.dart';

class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  int i = 1;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: Text('New Note')),
        body: Scrollbar(
            child: Container(
                height: 800,
                child: CupertinoTextField(
                  autocorrect: true,
                  autofocus: true,
                ))));
  }
}
