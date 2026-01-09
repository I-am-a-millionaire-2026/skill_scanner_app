import 'package:flutter/material.dart';
import 'package:skill_scanner/services/crud/notes_service.dart';

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;

  const NotesListView({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          // شما می‌توانید آیکون یا استایل قبلی خود را اینجا حفظ کنید
          leading: const Icon(Icons.note_alt_outlined),
        );
      },
    );
  }
}
