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
      body: Container(
      color: Colors.white,
      child: Center(child: SpinKitFadingCircle(
        color: Colors.blue,
        size: 100.0,
        )
    ))));
  }
}
