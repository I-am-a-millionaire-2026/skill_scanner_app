import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/notes/create_update_note_view.dart';
import 'firebase_options.dart'; // این خط مهمه

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // اگر اپ قبلاً ساخته شده بود، دوباره نساز
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // اگر duplicate app بود، ignore کن
    if (e.toString().contains('[core/duplicate-app]')) {
      debugPrint('Firebase app already initialized');
    } else {
      rethrow;
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: loginRoute,
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}
