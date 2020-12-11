import 'package:flutter/material.dart';
import 'package:notewriter_app/main.dart';
import './notes.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(children: [
      DrawerHeader(
          margin: EdgeInsets.all(8.0),
          child: Text(
            'Navigation',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          )),
      ListTile(
          trailing: Icon(Icons.camera_enhance),
          title: Text('Select Photo'),
          onTap: () {
            Navigator.push(
              context, 
              new MaterialPageRoute(builder: (context) => new LandingScreen())
            );
          }),
      ListTile(
          trailing: Icon(Icons.book),
          title: Text('My Notess'),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new Notes())
            );
          }),
    ]));
  }
}
