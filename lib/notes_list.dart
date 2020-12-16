import 'package:flutter/material.dart';
import './single_note.dart';

class NotesList extends StatelessWidget {
  final List<Widget> notes, name;
  NotesList(this.notes, this.name);
  
  @override
  Widget build(BuildContext context) {
    print(name);
    return Column(children: notes.map((element) => SingleNote(name.toString())).toList());
  }
}
