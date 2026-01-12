import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<String> _notes = [];

  void _addNewNote() async {
    final result = await Navigator.of(
      context,
    ).pushNamed(createOrUpdateNoteRoute);
    if (result != null && result is String) {
      setState(() {
        _notes.add(result);
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addNewNote),
        ],
      ),
      body: NotesListView(
        notes: _notes,
        onDelete: _deleteNote,
        onTap: (index) async {
          final note = _notes[index];
          final updatedNote = await Navigator.of(
            context,
          ).pushNamed(createOrUpdateNoteRoute, arguments: note);
          if (updatedNote != null && updatedNote is String) {
            setState(() {
              _notes[index] = updatedNote;
            });
          }
        },
      ),
    );
  }
}
