import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // اضافه شده
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart'; // اضافه شده
import 'package:skill_scanner/services/auth/bloc/auth_event.dart'; // اضافه شده
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
  late final FirebaseCloudStorage _notesService;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                // 1️⃣ و 2️⃣ ارسال رویداد خروج به AuthBloc (دستور 11)
                if (!mounted) return;
                context.read<AuthBloc>().add(const AuthEventLogOut());
                // جابجایی به صفحه لاگین توسط BlocBuilder در فایل main مدیریت می‌شود
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
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
                    Navigator.of(
                      context,
                    ).pushNamed(createOrUpdateNoteRoute, arguments: note);
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
