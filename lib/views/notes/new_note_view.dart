import 'package:flutter/material.dart';
import '../../services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final text = _textController.text;
    if (text.isNotEmpty) {
      await _notesService.addNote(text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter your note here...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveNote, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
