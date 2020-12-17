import 'package:flutter/material.dart';
import './single_note.dart';

class NotesList extends StatelessWidget {
  final List<String> notes;
  NotesList(this.notes);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: notes.map((element) => SingleNote(element)).toList());
  }
}
