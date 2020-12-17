import './note_editor.dart';
import './navbar.dart';
import './notes.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Future<Null> main() async {
  runApp(MaterialApp(home: LandingScreen()));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile;
  Dio dio = new Dio();

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
      return Container(
          margin: EdgeInsets.all(10.0), child: Text('No Image Selected'));
    } else {
      _uploadImage(imageFile);
      return Image.file(imageFile, height: 500);
    }
  }

  String url = 'http://139.162.146.78';
  TextEditingController nameController = TextEditingController();

  Future<void> _uploadImage(File imageFile) async {
    final uri = Uri.parse("");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameController.text;
    var pic = await http.MultipartFile.fromPath("image", imageFile.path);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Image Not Uploaded");
    }
  }

  String _response = null;

  Future<void> _getResponse() async {
    var response = await http.get(Uri.encodeFull(url));
    setState(() {
      _response = response.body.toString();
    });
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Detected Text:'),
            content: Text(_response),
            actions: [
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Keep'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new Editor(_response, 'New Note')));
                  })
            ],
          );
        });
  }

  _isImageLoaded() {
    if (imageFile != null) {
      return Container(
          margin: EdgeInsets.all(10.0),
          child: CupertinoButton(
              color: Colors.blue,
              disabledColor: Colors.grey[400],
              child: Text('Detect Text'),
              onPressed: () {
                _getResponse();
              }));
    } else {
      return Text('');
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
                child: Column(
                    children: <Widget>[_checkImage(), _isImageLoaded()]))),
        floatingActionButton: Container(
            height: 100.0,
            child: FittedBox(
                child: FloatingActionButton(
                    child: Icon(Icons.perm_media_outlined),
                    onPressed: () {
                      _showChoiceDialog(context);
                    }))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
