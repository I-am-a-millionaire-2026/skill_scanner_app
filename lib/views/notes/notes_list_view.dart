import 'package:flutter/material.dart';
import 'package:skill_scanner/services/cloud/cloud_note.dart'; // ✅ اضافه شدن برای استفاده از مدل کلود

// اصلاح تایپ‌دف‌ها برای کار با شیء نوت به جای ایندکس عددی
typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  // ✅ دستور شماره 10: استفاده از Iterable به جای List و CloudNote به جای String
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
        // ✅ دسترسی به نوت در Iterable با استفاده از elementAt
        final note = notes.elementAt(index);

        return ListTile(
          onTap: () => onTap(note), // ارسال کل نوت به تابع onTap
          title: Text(
            note.text, // نمایش متن اصلی نوت از کلود
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDeleteNote(note), // ارسال کل نوت برای حذف
          ),
        );
      },
    );
  }
}
