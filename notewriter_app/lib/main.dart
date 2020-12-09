import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import './navbar.dart';

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
      return Image.file(imageFile, width: 400, height: 400);
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Select Upload Method'),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    _openGallery();
                  },
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    _openCamera();
                  },
                )
              ])));
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.camera_enhance),
            onPressed: () {
              _showChoiceDialog(context);
            }),
      ),
    );
  }
}
