import 'package:flutter/material.dart';
import '../../services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  late final Stream<List<String>>
  _notesStream; // برای simplicity فرض شده String

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _notesStream = _notesService.allNotesStream(); // فرضی
  }

  void _createNewNote() {
    Navigator.of(context).pushNamed('/new_note');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Note'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _createNewNote),
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(title: Text(note));
            },
          );
        },
      ),
    );
  }
}
