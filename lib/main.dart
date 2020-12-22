import './note_editor.dart';
import './navbar.dart';
import './loading.dart';
import './notes.dart';
import './constants.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

Future<Null> main() async {
  runApp(MaterialApp(home: LandingScreen()));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool connection = false;
  bool loading = false;
  String deviceID;
  String url = 'http://139.162.146.78';
  TextEditingController nameController = TextEditingController();
  File imageFile;
  String status = '';
  String base64Image;
  File tempFile;
  String error = 'Error';

  Future<String> _getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/theme.csv';
    return filePath;
  }

  void _loadTheme() async {
    File themeFile = File(await _getFilePath());
    String theme = await themeFile.readAsString();
    if (theme == 'dark') {
      setState(() {
        darkMode = true;
      });
    } else {
      setState(() {
        darkMode = false;
      });
    }
  }

  _openGallery() async {
    var picture = await ImagePicker().getImage(
        source: ImageSource.gallery,
        imageQuality: 20,
        maxHeight: 800,
        maxWidth: 800);
    this.setState(() {
      imageFile = File(picture.path);
    });
    _setStatus('');
    Navigator.of(context);
  }

  _openCamera() async {
    var picture = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 20,
        maxHeight: 750,
        maxWidth: 750);
    this.setState(() {
      imageFile = File(picture.path);
    });
    _setStatus('');
    Navigator.of(context);
  }

  _checkImage() {
    if (imageFile == null) {
      return Container(
          margin: EdgeInsets.all(10.0), child: Text('No Image Selected'));
    } else {
      return Column(children: [
        FutureBuilder<File>(
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (null != imageFile) {
            tempFile = imageFile;
            base64Image = base64Encode(imageFile.readAsBytesSync());

            return Image.file(
              imageFile,
              width: 500,
              height: 500,
            );
          } else if (null != snapshot.error) {
            return Text('Error');
          }
        }),
        Container(
          padding: EdgeInsets.all(2.0),
          child: Text(
            'The Image Quality had been \nreduced to improve Performance',
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        )
      ]);
    }
  }

  _setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  _uploadImage() {
    if (null == tempFile) {
      _setStatus(error);
      return;
    }
    String fileName = 'image.jpg';
    _deleteOldImg(fileName);
    upload(fileName);
  }

  upload(String fileName) {
    http.post('http://www.041er-blj.ch/2020/dakapka/notewriter/db_upload.php',
        body: {
          "image": base64Image,
          "name": fileName,
        }).then((result) {
      _setStatus(result.statusCode == 200 ? result.body : error);
    }).catchError((error) {
      _setStatus(error);
    });
  }

  _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connection = true;
      }
    } on SocketException catch (_) {
      connection = false;
      return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('No Internet Connection!'),
              actions: [
                CupertinoDialogAction(
                  child: Text('Close'),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
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
                    setState(() => loading = false);
                    Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Keep'),
                  onPressed: () {
                    setState(() => loading = false);
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

  Future<void> _deleteOldImg(String fileName) async {
    http
        .delete(
      'http://www.041er-blj.ch/2020/dakapka/notewriter/image.jpg',
    )
        .then((result) {
      _setStatus(result.statusCode == 200 ? result.body : error);
    }).catchError((error) {
      _setStatus(error);
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
                _checkConnection();
                if (connection) {
                  setState(() => loading = true);
                  _uploadImage();
                  _getResponse();
                }
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
    setState(() {
      _loadTheme();
    });
    return loading
        ? Loading()
        : MaterialApp(
            theme: darkMode ? ThemeData.dark() : ThemeData(),
            home: Scaffold(
              appBar: AppBar(title: Text('Select Photo')),
              drawer: NavBar(),
              body: Scrollbar(
                  child: Container(
                      child: Center(
                          child: Column(children: <Widget>[
                _checkImage(),
                _isImageLoaded()
              ])))),
              floatingActionButton: Container(
                  height: 100.0,
                  child: FittedBox(
                      child: FloatingActionButton(
                          backgroundColor:
                              darkMode ? Colors.grey[700] : Colors.blue[400],
                          child: Icon(
                            Icons.perm_media_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _showChoiceDialog(context);
                          }))),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          );
  }
}
