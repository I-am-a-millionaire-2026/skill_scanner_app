import 'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  // تعریف کنترلر برای متن نوت
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // متدی که با زدن دکمه تیک اجرا می‌شود
  void _saveNote() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      print('Note to be saved: $text'); // فعلاً برای تست در کنسول چاپ می‌کند
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote, // فراخوانی متد ذخیره
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Enter your note here...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
