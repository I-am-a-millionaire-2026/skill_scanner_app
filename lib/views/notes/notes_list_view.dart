import 'package:flutter/material.dart';

typedef NoteTapCallback = void Function(int index);
typedef NoteDeleteCallback = void Function(int index);

class NotesListView extends StatelessWidget {
  final List<String> notes;
  final NoteDeleteCallback onDelete;
  final NoteTapCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDelete,
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
        final note = notes[index];
        return ListTile(
          title: Text(note),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(index),
          ),
          onTap: () => onTap(index),
        );
      },
    );
  }
}
