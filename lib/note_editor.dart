import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:device_info/device_info.dart';

import './notes.dart';

class Editor extends StatefulWidget {
  final String _response;
  Editor(this._response);
  @override
  _EditorState createState() => _EditorState(_response);
}

class _EditorState extends State<Editor> {
  final String _response;
  _EditorState(this._response);

  final nameController = TextEditingController();
  final noteController = TextEditingController();
  String nameString = '';
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

  void _saveNewNote(String nameController, String noteController) async {
    var settings = new ConnectionSettings(
        host: 'mysql2.webland.ch',
        user: 'd041e_dakapka',
        password: '12345_Db!!!',
        db: 'd041e_dakapka');

    _getDeviceID();
    var conn = await MySqlConnection.connect(settings);
    var name = nameController;
    var note = noteController;
    var date = DateTime.now();
    var insert = await conn.query(
        'INSERT INTO notes (device_id, title, created_at, text_value) VALUES (?, ?, ?, ?)',
        ['$deviceID', '$name', '$date', '$note']);
  }

  Future<void> _getNoteName() async {
    File path = File(await _getFilePath());
    String noteNameString = await path.readAsString();
    nameString = noteNameString;
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String _nameCheck() {
    if (nameString == '') {
      return 'New Note';
    } else {
      return nameString;
    }
  }

  Widget build(BuildContext context) {
    noteController.text = _response;
    return new Scaffold(
        appBar: new AppBar(
          title: Text(_nameCheck()),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    return showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text('Save as: '),
                            content: CupertinoTextField(
                              autofocus: true,
                              controller: nameController,
                              autocorrect: false,
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
                                  if (nameString == '') {
                                    _saveNewNote(nameController.text,
                                        noteController.text);
                                  }

                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context, 
                                    new MaterialPageRoute(builder: (context) => new Notes())
                                  );
                                },
                                child: Text('Save'),
                                isDefaultAction: true,
                              )
                            ],
                          );
                        });
                  },
                  child: Icon(Icons.save),
                )),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => new Notes()));
                },
                child: Icon(Icons.cancel),
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
