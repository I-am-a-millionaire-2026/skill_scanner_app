import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/auth_gate.dart';
// آدرس‌های جدید بعد از جابه‌جایی به پوشه notes
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/notes/new_note_view.dart';

void main() {
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
        newNoteRoute: (context) =>
            const NewNoteView(), // مرحله ۸: ثبت مسیر جدید
      },
    ),
  );
}
