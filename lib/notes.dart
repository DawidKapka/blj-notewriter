import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notewriter_app/notes_list.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:device_info/device_info.dart';
import 'dart:io';
import './constants.dart';

import './navbar.dart';
import './single_note.dart';
import './main.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

var deviceID = '';
bool showHint = true;

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
  List<String> _notes = [];
  List<String> noteName = [];
  Future<List> _getNotes() async {
    var settings = new mysql.ConnectionSettings(
        host: 'mysql2.webland.ch',
        user: 'd041e_dakapka',
        password: '12345_Db!!!',
        db: 'd041e_dakapka');

    _getDeviceID();
    var conn = await mysql.MySqlConnection.connect(settings);
    var selectNotes = await conn
        .query('SELECT * FROM notes WHERE device_id = ?', ['$deviceID']);
    for (var row in selectNotes) {
      setState(() {
        _notes.add(row[2].toString());
        noteName.add(row[2]);
      });
    }
    conn.close();
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
    setState(() {});
    return new MaterialApp(
      theme: darkMode ? ThemeData.dark() : ThemeData(),
      home: Scaffold(
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
                  color: darkMode ? Colors.grey[700] : Colors.blue,
                  disabledColor: Colors.grey[400],
                  onPressed: () {
                    setState(() {
                      _notes.insert(0, 'New Note');
                    });
                  })),
          Container(
              margin: EdgeInsets.all(3.0),
              padding: EdgeInsets.only(left: 60.0, right: 60.0),
              child: Center(
                  child: showHint ? Container(
                      decoration: BoxDecoration(
                        color: darkMode ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hint: Hold Note Pressed to show Content',
                                style: TextStyle(
                                    color: darkMode ? Colors.grey[200] : Colors.grey[600], fontSize: 12)),
                            
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showHint = false;
                                      });
                                    },
                                    child: Icon(Icons.cancel_outlined,
                                        color: Colors.grey[600]))
                          ])) : Container())),
          NotesList(_notes),
          _isNotesEmpty(context)
        ]))));
  }
}
