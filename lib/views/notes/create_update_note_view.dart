import 'package:flutter/material.dart';
import 'package:skill_scanner/services/crud/notes_service.dart';

class CreateUpdateNoteView extends StatefulWidget {
  final Note? note;

  const CreateUpdateNoteView({super.key, this.note});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  final NotesService _notesService = NotesService();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    if (widget.note == null) {
      await _notesService.addNote(title, content);
    } else {
      await _notesService.updateNote(widget.note!.id, title, content);
    }

    Navigator.of(
      context,
    ).pop(); // نیازی به pop با داده نیست، StreamBuilder خودش رفرش می‌کند
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(hintText: 'Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
