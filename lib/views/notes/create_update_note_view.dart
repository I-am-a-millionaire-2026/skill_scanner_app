import 'package:flutter/material.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/utilities/generics/get_arguments.dart';

// ✅ دستور شماره 4: اضافه کردن importهای مورد نیاز برای کلود
import 'package:skill_scanner/services/cloud/cloud_note.dart';
import 'package:skill_scanner/services/cloud/cloud_storage_exceptions.dart';
import 'package:skill_scanner/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;

  // ✅ دستور شماره 5: تعریف سرویس به عنوان FirebaseCloudStorage
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage(); // مقداردهی سرویس کلود
    _textController = TextEditingController();
    super.initState();
  }

  // ✅ متد کمکی برای اجرای دستور شماره 9 (بروزرسانی در هنگام تایپ)
  void _textControllerListener() async {
    final note = _note;
    if (note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(documentId: note.documentId, text: text);
  }

  // ✅ فعال‌سازی شنونده برای تغییرات متن
  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  // ✅ دستور شماره 6: هماهنگ کردن تابع با Cloud Storage
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;

    // ✅ دستور شماره 7: ایجاد نوت جدید در کلود
    final newNote = await _notesService.createNewNote(
      ownerUserId: userId,
      text: '',
    );
    _note = newNote;
    return newNote;
  }

  // ✅ دستور شماره 8: حذف امن نوت از کلود
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  // ✅ دستور شماره 9: Fix updating notes
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_textControllerListener); // پاکسازی شنونده
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // ✅ بعد از آماده شدن نوت، شنونده را فعال می‌کنیم
              _setupTextControllerListener();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
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
