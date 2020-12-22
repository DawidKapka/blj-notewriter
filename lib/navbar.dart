import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notewriter_app/main.dart';
import './notes.dart';
import './settings.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      DrawerHeader(
          margin: EdgeInsets.all(8.0),
          child: Text(
            'Note\n     Writer+',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
          )),
      ListTile(
          trailing: Icon(Icons.camera_enhance),
          title: Text('Select Photo'),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new LandingScreen()));
          }),
      ListTile(
          trailing: Icon(Icons.book),
          title: Text('My Notes'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Notes()));
          }),
      ListTile(
          trailing: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Settings()));
          })
    ]));
  }
}
