import 'dart:developer';

import './note_editor.dart';
import './navbar.dart';
import './notes.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
      return Container(
          margin: EdgeInsets.all(10.0), child: Text('No Image Selected'));
    } else {
      return Image.file(imageFile, height: 500);
    }
  }

  String url = '';
  _getUrl() {
    if (Platform.isAndroid) {
      url = "http://10.0.2.2:5000/result";
    } else {
      url = "http://127.0.0.1:5000/result";
    }
  }

  Future<String> _getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/text.txt';
    return filePath;
  }

  void _saveFile() async {
    File file = File(await _getFilePath());
    file.writeAsString(imageFile.toString());

  }

  String _response = null;

  Future<void> _getResponse() async {
    _saveFile();
    _getUrl();
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
                            builder: (context) => new Editor(_response)));
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
