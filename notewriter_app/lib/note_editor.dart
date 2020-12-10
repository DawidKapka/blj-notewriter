import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './navbar.dart';

class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Note 1')
      ),
      drawer: NavBar(),
      body: Container()
    );
  }
}
