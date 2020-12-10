import 'dart:io';
import './navbar.dart';
import './notes.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';

Future<Null> main() async {
  runApp(MaterialApp(home: LandingScreen()));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile;

  _openGallery() async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context);
  }

  _openCamera() async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context);
  }

  _checkImage() {
    if (imageFile == null) {
      return Text('No Image Selected');
    } else {
      return Image.file(imageFile, height: 500);
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Choose Upload Method'),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    _openCamera();
                    Navigator.of(context).pop();
                  },
                  child: Text('Camera')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    _openGallery();
                    Navigator.of(context).pop();
                  },
                  child: Text('Gallery')),
            ],
            cancelButton: CupertinoActionSheetAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('NoteWriter+')),
        drawer: NavBar(),
        body: Container(
            child: Center(
                child: Column(children: <Widget>[
          _checkImage(),
        ]))),
        floatingActionButton: Container(
          height: 100.0,
          child: FittedBox(
            child: FloatingActionButton(
            child: Icon(Icons.camera_enhance),
            onPressed: () {
              _showChoiceDialog(context);
            }))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
