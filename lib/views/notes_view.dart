import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/enums/menu_action.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/services/crud/notes_service.dart';
import 'package:skill_scanner/utilities/show_logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = NotesService(); // استفاده از Singleton
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    if (!mounted) return;
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      // مرحله ۹ و ۱۳: ترکیب دو بیلدر برای مدیریت دیتابیس و نمایش زنده داده‌ها
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState
                .done: // مرحله ۱۴: وقتی ساخت/یافتن کاربر تمام شد
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState
                        .waiting: // مرحله ۱۴: در انتظار اولین داده استریم
                    case ConnectionState
                        .active: // مرحله ۱۴: وقتی استریم داده می‌فرستد
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return ListView.builder(
                          itemCount: allNotes.length,
                          itemBuilder: (context, index) {
                            final note = allNotes[index];
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
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
              );
            default: // مرحله ۱۴: وضعیت .waiting برای FutureBuilder
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
