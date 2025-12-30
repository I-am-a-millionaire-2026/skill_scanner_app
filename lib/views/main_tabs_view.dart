import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/firebase_options.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/notes_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // حل مشکل Duplicate App
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    MaterialApp(
      title: 'Skill Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthGate(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}
