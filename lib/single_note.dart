import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:notewriter_app/note_editor.dart';
import 'package:mysql1/mysql1.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

import './note_editor.dart';

class SingleNote extends StatelessWidget {
  final String nameNote;
  SingleNote(this.nameNote);
  @override
  String noteText;
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

  Widget build(BuildContext context) {
    return ListTile(
            title: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Editor('', nameNote)));
                },
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue[200],
                      border: Border.all(width: 2.0, color: Colors.blue[200])),
                  child: Text(nameNote,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )));
  }
}
