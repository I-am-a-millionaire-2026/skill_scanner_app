import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await user.reload(); // 🔹 بارگذاری آخرین اطلاعات از Firebase
        setState(() {
          _user = FirebaseAuth.instance.currentUser;
          _isLoading = false;
        });
      } else {
        setState(() {
          _user = null;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = _user;
    if (user == null) return const LoginView();

    if (!user.emailVerified) return const VerifyEmailView();

    return const NotesView();
  }
}
