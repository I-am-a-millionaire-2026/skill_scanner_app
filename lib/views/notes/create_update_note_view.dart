import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  final TextEditingController _textController = TextEditingController();
  String? _noteText;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        _noteText = args;
        _textController.text = _noteText!;
      }
      _isInitialized = true;
    }
  }

  void _saveNote() {
    final text = _textController.text;
    if (text.isEmpty) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(text); // متن نوت به NotesView برگردانده می‌شود
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Note'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textController,
          maxLines: null,
          decoration: const InputDecoration(hintText: 'Type your note here...'),
        ),
      ),
    );
  }
}
