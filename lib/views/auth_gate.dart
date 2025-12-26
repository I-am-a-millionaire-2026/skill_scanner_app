import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ایمپورت‌ها با مسیر پکیج (امن‌ترین حالت)
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/notes_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ⏳ در حال بررسی وضعیت لاگین (اتصال به Firebase)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ اگر کاربر لاگین نکرده باشد، او را به صفحه ورود می‌فرستیم
        if (!snapshot.hasData) {
          return const LoginView();
        }

        final user = snapshot.data!;

        // ⚠️ اگر کاربر لاگین است اما ایمیلش را تایید نکرده است
        if (!user.emailVerified) {
          return const VerifyEmailView();
        }

        // ✅ اگر کاربر لاگین است و ایمیلش تایید شده، به صفحه یادداشت‌ها می‌رود
        return const NotesView();
      },
    );
  }
}
