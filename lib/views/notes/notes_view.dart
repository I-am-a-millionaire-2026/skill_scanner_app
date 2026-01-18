import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/services/cloud/cloud_note.dart'; // برای جایگزینی Note قدیمی با CloudNote
import 'package:skill_scanner/services/cloud/firebase_cloud_storage.dart'; // برای جایگزینی NotesService قدیمی
import 'package:skill_scanner/views/notes/notes_list_view.dart'; // اگر لیست را در فایل جدا دارید

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // تغییر از NotesService محلی به FirebaseCloudStorage ابری (دستور 21)
  late final FirebaseCloudStorage _notesService;

  // استفاده از ID کاربر برای فیلتر کردن نوت‌ها (دستور 30)
  String get userId => AuthService.firebase().currentUser!.id;

  String get userEmail =>
      AuthService.firebase().currentUser!.email; // ✅ دستور 11

  @override
  void initState() {
    _notesService = FirebaseCloudStorage(); // مقداردهی سرویس جدید (دستور 26)
    super.initState();
  }

  void _logout() async {
    await AuthService.firebase().logOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
  }

  void _openCreateNote() {
    // اصلاح ناوبری به صورت Named Route برای هماهنگی با آرگومان‌ها
    Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
  }

  void _editNote(CloudNote note) {
    // اصلاح بخش ارور دار: نوت به عنوان argument فرستاده می‌شود (رفع ارور تصویر شما)
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
      // استفاده از Stream برای دریافت نوت‌های ابری کاربر (دستور 30)
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;

                // نمایش نوت‌ها (اگر فایل NotesListView را ندارید، لیست را همینجا بسازید)
                return ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    final note = allNotes.elementAt(index);
                    return ListTile(
                      title: Text(
                        note.text,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _editNote(note),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _notesService.deleteNote(
                            documentId: note.documentId,
                          );
                        },
                      ),
                    );
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
