import 'package:flutter/material.dart';
import 'package:skill_scanner/services/cloud/cloud_note.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skill_scanner/utilities/dialogs/cannot_share_empty_note_dialog.dart'; // ✅ اضافه شد

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(child: Text('No notes yet. Click + to add.'));
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);

        return ListTile(
          onTap: () => onTap(note),
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  // ✅ بررسی نوت خالی در لیست
                  if (note.text.isEmpty) {
                    await showCannotShareEmptyNoteDialog(context);
                  } else {
                    Share.share(note.text);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDeleteNote(note),
              ),
            ],
          ),
        );
      },
    );
  }
}
