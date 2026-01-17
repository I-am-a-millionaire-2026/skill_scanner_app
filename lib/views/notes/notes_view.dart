import 'package:flutter/material.dart';
import 'package:skill_scanner/services/crud/notes_service.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'create_update_note_view.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final NotesService _notesService = NotesService();

  String get userEmail =>
      AuthService.firebase().currentUser!.email; // ✅ دستور 11

  void _logout() async {
    await AuthService.firebase().logOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
  }

  void _openCreateNote() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CreateUpdateNoteView()));
  }

  void _editNote(Note note) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CreateUpdateNoteView(note: note)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes ($userEmail)'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _openCreateNote),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: _notesService.allNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () => _editNote(note),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _notesService.deleteNote(note.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
