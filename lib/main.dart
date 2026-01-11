import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/notes/notes_view.dart';
import 'views/notes/new_note_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // فقط اگر Firebase هنوز initialize نشده، initialize کن
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/notes',
      routes: {
        '/notes': (context) => const NotesView(),
        '/new_note': (context) => const NewNoteView(),
      },
    );
  }
}
