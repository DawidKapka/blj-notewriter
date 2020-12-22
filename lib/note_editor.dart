import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notewriter_app/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:device_info/device_info.dart';

import './notes.dart';

class Editor extends StatefulWidget {
  final String _response;
  String nameTitle;
  Editor(this._response, this.nameTitle);
  @override
  _EditorState createState() => _EditorState(_response, nameTitle);
}

class _EditorState extends State<Editor> {
  bool noteExists;
  String _response;
  String nameTitle;
  _EditorState(this._response, this.nameTitle);

  void _deleteNote(String nameTitle) async {
    var settings = new ConnectionSettings(
        host: 'mysql2.webland.ch',
        user: 'd041e_dakapka',
        password: '12345_Db!!!',
        db: 'd041e_dakapka');
    _getDeviceID();
    var conn = await MySqlConnection.connect(settings);
    var deleteNote = await conn.query(
        'DELETE FROM notes WHERE device_id = ? AND title = ?',
        ['$deviceID', '$nameTitle']);
  }

  Future<void> _getNote() async {
    var settings = new ConnectionSettings(
        host: 'mysql2.webland.ch',
        user: 'd041e_dakapka',
        password: '12345_Db!!!',
        db: 'd041e_dakapka');
    var conn = await MySqlConnection.connect(settings);
    _getDeviceID();
    var getNote = await conn.query(
        'SELECT * FROM notes WHERE device_id = ? AND title = ?',
        ['$deviceID', '$nameTitle']);
    for (var row in getNote) {
      if (row != null) {
        noteController.text = row[4].toString();
      }
    }
    //print(deviceID);
    //print(nameTitle);
    //print(getNote);
  }

  final nameController = TextEditingController();
  final noteController = TextEditingController();
  String nameString = '';
  String deviceID = '';
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

  Future<String> _getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    final Directory notesFolder = Directory('$appDocumentsPath/Notes/');
    if (!notesFolder.existsSync()) {
      await notesFolder.create(recursive: true);
    }
    String date = DateTime.now().toString();
    String filePath = '$appDocumentsPath/Notes/note.$date.csv';
    return filePath;
  }

  var settings = new ConnectionSettings(
      host: 'mysql2.webland.ch',
      user: 'd041e_dakapka',
      password: '12345_Db!!!',
      db: 'd041e_dakapka');

  void _saveNewNote(String nameController, String noteController) async {
    _getDeviceID();
    var conn = await MySqlConnection.connect(settings);
    var name = nameController;
    var note = noteController;
    var date = DateTime.now();
    var insert = await conn.query(
        'INSERT INTO notes (device_id, title, created_at, text_value) VALUES (?, ?, ?, ?)',
        ['$deviceID', '$name', '$date', '$note']);
    conn.close();
  }

  void _updateNote(String noteController) async {
    _getDeviceID();
    var conn = await MySqlConnection.connect(settings);
    var update = await conn.query(
        'UPDATE notes SET text_value = ? WHERE device_id = ? AND title = ?',
        ['$noteController', '$deviceID', '$nameTitle']);
    conn.close();
  }

  Future<void> _getNoteName() async {
    File path = File(await _getFilePath());
    String noteNameString = await path.readAsString();
    nameString = noteNameString;
  }

  String _nameCheck() {
    if (nameString == '' && nameTitle == '') {
      return 'New Note';
    } else {
      return nameTitle;
    }
  }

  _checkForName() async {
    _getDeviceID();
    var conn = await MySqlConnection.connect(settings);
    var check = await conn
        .query('SELECT * FROM notes WHERE device_id = ?', ['$deviceID']);
    if (check.isEmpty) {
      noteExists = false;
    } else {
      for (var row in check) {
        if (row[2] == nameTitle) {
          noteExists = true;
          break;
        } else {
          noteExists = false;
        }
      }
    }
    conn.close();
  }

  Widget build(BuildContext context) {
    if (noteController.text == '') {
      setState(() {
        noteController.text = _response;
        _getNote();
      });
    }

    return new Scaffold(
        appBar: new AppBar(
          title: Text(_nameCheck()),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _checkForName();
                    if (noteExists != null) {
                      if (noteExists == false) {
                        return showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Save as: '),
                                content: CupertinoTextField(
                                  autofocus: true,
                                  controller: nameController,
                                  placeholder: 'New Note',
                                  autocorrect: true,
                                  maxLines: 1,
                                  maxLength: 50,
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text('Cancel'),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      _saveNewNote(nameController.text,
                                          noteController.text);
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new Notes()));
                                    },
                                    child: Text('Save'),
                                    isDefaultAction: true,
                                  )
                                ],
                              );
                            });
                      } else {
                        _updateNote(noteController.text);
                        Navigator.of(context).pop();
                      }
                      return showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              Navigator.of(context).pop();
                            });
                            return CupertinoAlertDialog(
                              title: Text('Saved!'),
                            );
                          });
                    }
                  },
                  child: Icon(Icons.save),
                )),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  return showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('Remove $nameTitle?'),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: Text('Remove'),
                              onPressed: () {
                                _deleteNote(nameTitle);
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Notes()));
                              },
                            )
                          ],
                        );
                      });
                },
                child: Icon(Icons.delete),
              ),
            )
          ],
        ),
        body: Scrollbar(
            child: Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: noteController,
                  keyboardAppearance: Brightness.light,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  autofocus: true,
                ))));
  }
}
