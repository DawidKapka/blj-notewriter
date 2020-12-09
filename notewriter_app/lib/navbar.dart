import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(children: [
      DrawerHeader(
        
        child: Text('Navigation')),
      ListTile(
        trailing: Icon(Icons.camera_enhance),
        title: Text('Camera'),
      ),
      ListTile(
        trailing: Icon(Icons.book) , 
        title: Text('My Notes')),
    ]));
  }
}
