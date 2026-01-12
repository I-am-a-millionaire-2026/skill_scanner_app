import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // اضافه برای دسترسی مستقیم به User

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please check your email to verify your account.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // دکمه ارسال مجدد ایمیل تایید
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification email sent again!'),
                    ),
                  );
                }
              },
              child: const Text('Resend verification email'),
            ),
            const SizedBox(height: 20),

            // دکمه Restart (خروج از حساب و رفتن به Register)
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                if (!mounted) return;
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Restart'),
            ),
            const SizedBox(height: 20),

            // دکمه تایید ایمیل Reload
            TextButton(
              onPressed: () async {
                // دسترسی مستقیم به کاربر firebase
                final firebaseUser = FirebaseAuth.instance.currentUser;
                await firebaseUser?.reload(); // اینجا خطا نخواهد داد
                final updatedUser = FirebaseAuth.instance.currentUser;

                if (updatedUser?.emailVerified ?? false) {
                  // اگر تایید شده بود، برو به صفحه یادداشت‌ها
                  if (!mounted) return;
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  // اگر هنوز تایید نشده، پیام نمایش بده
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please verify your email first.'),
                    ),
                  );
                }
              },
              child: const Text('I have verified, let me in!'),
            ),
          ],
        ),
      ),
    );
  }
}
