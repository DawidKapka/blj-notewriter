import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import './navbar.dart';
import './constants.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<String> _getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/theme.csv';
    return filePath;
  }

  void _saveTheme() async {
    File themeFile = File(await _getFilePath());
    themeFile.writeAsString(darkMode ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: darkMode ? ThemeData.dark() : ThemeData(),
        home: Scaffold(
          appBar: AppBar(title: Text('Settings')),
          drawer: NavBar(),
          body: Container(
            child: Column(children: [
              Center(
                  child: Container(
                      margin: EdgeInsets.all(20.0),
                      child: CupertinoButton(
                        color: darkMode ? Colors.grey[700] : Colors.blue,
                        child: darkMode
                            ? Text('Switch to Light Theme')
                            : Text('Switch to Dark Theme'),
                        onPressed: () {
                          setState(() {
                            if (darkMode == false) {
                              darkMode = true;
                            } else {
                              darkMode = false;
                            }
                            _saveTheme();
                          });
                        },
                      )))
            ]),
          ),
        ));
  }
}
