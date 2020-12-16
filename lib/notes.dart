import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notewriter_app/notes_list.dart';
import 'package:mysql1/mysql1.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

import './navbar.dart';
import './single_note.dart';
import './main.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

var deviceID = '';

Future<void> _getDeviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceID = androidInfo.androidId;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceID = iosInfo.identifierForVendor;
  }
}

class _NotesState extends State<Notes> {
  List<Widget> _notes = [];
  List<Widget> noteName = [];
  Future<List> _getNotes() async {
    var settings = new ConnectionSettings(
        host: 'mysql2.webland.ch',
        user: 'd041e_dakapka',
        password: '12345_Db!!!',
        db: 'd041e_dakapka');

    _getDeviceID();
    var conn = await MySqlConnection.connect(settings);
    var selectNotes = await conn
        .query('SELECT * FROM notes WHERE device_id = ?', ['$deviceID']);
    for (var row in selectNotes) {
      setState(() {
        _notes.add(Text(row[2].toString()));
        noteName.add(Text(row[2].toString()));
      });
      print(_notes);
    }
  }

  TextEditingController nameController = new TextEditingController();
  String title;
  @override
  void initState() {
    _getNotes();
  }

  Center _isNotesEmpty(BuildContext context) {
    if (_notes.length == 0) {
      return Center(child: Text("It's pretty empty in here..."));
    } else {
      return Center(child: Text(''));
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('My Notes'),
        ),
        drawer: NavBar(),
        body: Scrollbar(
            child: ListView(children: [
          Container(
              margin: EdgeInsets.all(8.0),
              child: CupertinoButton(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(Icons.note_add_outlined),
                  color: Colors.blue,
                  disabledColor: Colors.grey[400],
                  onPressed: () {
                    setState(() {
                      _notes.add(Text('New Note'));
                    });
                  })),
          NotesList(_notes, noteName),
          _isNotesEmpty(context)
        ])));
  }
}
