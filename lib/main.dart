import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skill_scanner/firebase_options.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/notes_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase already initialized');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Master Me',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primarySwatch: Colors.blue,
      ),
      initialRoute: loginRoute,
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}
