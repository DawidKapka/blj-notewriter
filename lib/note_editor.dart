import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './navbar.dart';
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('New Note'),
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
                              autocorrect: false,
                              maxLines: null,
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
                  keyboardAppearance: Brightness.light,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  initialValue: _response,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  autofocus: true,
                ))));
  }
}
