import 'package:flutter/material.dart';
import './single_note.dart';

class NotesList extends StatelessWidget {
  final List<Widget> notes;
  final String nameController;
  NotesList(this.notes, this.nameController);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: notes.map((element) => SingleNote(nameController.toString())).toList());
  }
}
