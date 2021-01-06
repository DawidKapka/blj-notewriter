import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './navbar.dart';
import './constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: darkMode ? ThemeData.dark() : ThemeData(),
      home: Scaffold(
      appBar: AppBar(title: Text('Loading...')),
      body: Container(
      color: darkMode ? Colors.grey[900] : Colors.white,
      child: Center(child: SpinKitFadingCircle(
        color: Colors.blue,
        size: 100.0,
        )
    ))));
  }
}
 