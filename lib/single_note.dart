import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:notewriter_app/note_editor.dart';
import 'package:mysql1/mysql1.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

import './note_editor.dart';
import './constants.dart';

class SingleNote extends StatefulWidget {
  final String nameNote;
  SingleNote(this.nameNote);

  @override
  _SingleNoteState createState() => _SingleNoteState(nameNote);
}

class _SingleNoteState extends State<SingleNote> {
  final String nameNote;
  _SingleNoteState(this.nameNote);
  @override
  String noteText = '';
  String noteDate = '';
  bool showAll = false;
  String deviceID;

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

  _getNoteValue(String nameNote) async {
    var settings = new ConnectionSettings(
        host: 'mysql2.webland.ch',
        user: 'd041e_dakapka',
        password: '12345_Db!!!',
        db: 'd041e_dakapka');
    _getDeviceID();
    var conn = await MySqlConnection.connect(settings);
    var getText = await conn.query(
        'SELECT * FROM notes WHERE device_id = ? AND title = ?',
        ['$deviceID', '$nameNote']);
    if (getText != null) {
      for (var row in getText) {
        noteText = row[4];
        print(row[3]);
        var date = row[3].toString();
        print(date);
        noteDate = "Last Saved: $date";
        print(noteDate);
      }
    }
    conn.close();
  }

  Widget build(BuildContext context) {
    _getNoteValue(nameNote);
    return ListTile(
        title: GestureDetector(
            onLongPressEnd: (void press) {
              setState(() {
                showAll = false;
              });
            },
            onLongPress: () {
              setState(() {
                showAll = true;
              });
            },
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new Editor('', widget.nameNote)));
            },
            child: Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  boxShadow: showAll
                      ? [
                          BoxShadow(
                              color: darkMode
                                  ? Colors.grey[900]
                                  : Colors.grey[300],
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(0, 3))
                        ]
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  color: darkMode ? Colors.grey[700] : Colors.lightBlue[200],
                  border: Border.all(
                      width: 2.0,
                      color:
                          darkMode ? Colors.grey[700] : Colors.lightBlue[200])),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Center(
                            child: Text(widget.nameNote,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)))),
                    showAll
                        ? Text("$noteDate $noteText",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: darkMode
                                    ? Colors.white60
                                    : Colors.grey[700]))
                        : Text(
                            '',
                            style: TextStyle(fontSize: 0),
                          ),
                  ]),
            )));
  }
}
