import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/firebase_options.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ SAFELY initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If it's already initialized, we just ignore the error and proceed
    debugPrint('Firebase already initialized: $e');
  }

  // ✅ Setup the Auth Service instance
  await AuthService.firebase().initializeOnce();

  runApp(const SkillScannerApp());
}

class SkillScannerApp extends StatelessWidget {
  const SkillScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check user status directly since everything is initialized in main()
    final user = AuthService.firebase().currentUser;
    if (user != null) {
      if (user.isEmailVerified) {
        return const NotesView();
      } else {
        return const VerifyEmailView();
      }
    } else {
      return const LoginView();
    }
  }
}
