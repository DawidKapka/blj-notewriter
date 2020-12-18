import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './navbar.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(title: Text('NoteWriter+')),
      drawer: NavBar(),
      body: Container(
      color: Colors.white,
      child: SpinKitFadingCircle(
        color: Colors.blue,
        size: 50.0,
        )
    )));
  }
}
