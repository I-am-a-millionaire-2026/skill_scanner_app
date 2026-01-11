import 'package:flutter/material.dart';

class NotesListView extends StatelessWidget {
  final List<String> notes; // ← قبلاً DatabaseNote بود
  final void Function(String note) onTap;

  const NotesListView({super.key, required this.notes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(child: Text('No notes yet'));
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(title: Text(note), onTap: () => onTap(note));
      },
    );
  }
}
