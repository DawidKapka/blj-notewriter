import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notewriter_app/navbar.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      drawer: NavBar(),
      body: Scrollbar(
        child: Container(
          child: Center(
            child: ListView(children: [Icon(Icons.find_in_page), 
            Center(child: Text('Coming Soon', 
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic
            )
        ,))
        ]
        ))
      ))
    );
  }
}
