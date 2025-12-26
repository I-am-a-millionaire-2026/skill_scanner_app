import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skill_scanner/firebase_options.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/notes_view.dart';
import 'package:skill_scanner/constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // حل مشکل صفحه سفید و خطای تکراری بودن فایربیس
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase is already running');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Scanner',
      theme: ThemeData(
        brightness: Brightness.dark, // تم تیره هماهنگ با عکس پروفایل شما
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      initialRoute: loginRoute,
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
      },
    );
  }
}
