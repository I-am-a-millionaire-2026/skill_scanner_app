import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/services/cloud/cloud_note.dart';
import 'package:skill_scanner/services/cloud/firebase_cloud_storage.dart';
import 'package:skill_scanner/utilities/dialogs/logout_dialog.dart';
import 'package:skill_scanner/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // ✅ دستور شماره 13: استفاده از سرویس FirebaseCloudStorage به جای سرویس قدیمی
  late final FirebaseCloudStorage _notesService;

  // ✅ دستور شماره 12: گرفتن مستقیم userId از AuthService برای اتصال امن به نوت‌ها
  String get userId => AuthService.firebase().currentUser!.id;

  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage(); // مقداردهی سرویس جدید
    super.initState();
  }

  void _logout() async {
    final shouldLogout = await showLogOutDialog(context);
    if (shouldLogout) {
      await AuthService.firebase().logOut();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
    }
  }

  void _openCreateNote() {
    Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
  }

  void _editNote(CloudNote note) {
    Navigator.of(context).pushNamed(createOrUpdateNoteRoute, arguments: note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes ($userEmail)'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _openCreateNote),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      // ✅ دستور شماره 11: حذف FutureBuilder اضافی؛ مستقیماً از StreamBuilder استفاده می‌کنیم
      body: StreamBuilder(
        // استفاده از سرویس ابری برای دریافت لحظه‌ای نوت‌ها بر اساس userId
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    _editNote(note);
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
