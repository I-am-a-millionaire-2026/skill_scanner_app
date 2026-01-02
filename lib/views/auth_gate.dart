import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/notes/notes_view.dart'; // مسیر جدید اصلاح شد
import 'package:skill_scanner/views/verify_email_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginView();
        }

        final authUser = AuthUser.fromFirebase(user);

        if (!authUser.isEmailVerified) {
          return const VerifyEmailView();
        }

        return const NotesView(); // استفاده از کلاس صحیح
      },
    );
  }
}
