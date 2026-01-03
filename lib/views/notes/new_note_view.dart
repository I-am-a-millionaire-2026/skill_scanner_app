import 'package:flutter/material.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  // 1️⃣ متغیرها (دستور ۲، ۳ و ۴)
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  // 9️⃣ مقداردهی اولیه (دستور ۹)
  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    _setupTextControllerListener(); // دستور ۱۱
    super.initState();
  }

  // 1️⃣0️⃣ لیسنر برای ذخیره خودکار هنگام تایپ (دستور ۱۰)
  void _textControllerListener() async {
    final note = _note;
    if (note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  // 1️⃣1️⃣ متصل کردن کنترلر به لیسنر (دستور ۱۱)
  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  // 5️⃣ متد ساخت نوت جدید (دستور ۵)
  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = _note;
    if (widgetNote != null) {
      return widgetNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getOrCreateUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  // 6️⃣ حذف نوت خالی (دستور ۶)
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  // 7️⃣ ذخیره نوت غیرخالی (دستور ۷)
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  // 8️⃣ پاکسازی منابع (دستور ۸)
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  // 1️⃣2️⃣ طراحی رابط کاربری (دستور ۱۲)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                    border: InputBorder.none,
                  ),
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
