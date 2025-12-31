import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/notes_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/auth_gate.dart';

void main() async {
  // اطمینان از اتصال موتور فلاتر
  WidgetsFlutterBinding.ensureInitialized();

  // استفاده از سرویس برای مقداردهی ایمن (بدون ارور Duplicate)
  await AuthService.firebase().initialize();

  runApp(
    MaterialApp(
      title: 'Skill Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // صفحه شروع بر اساس وضعیت لاگین
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
