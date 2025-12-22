import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // برای دسترسی به AuthGate جهت رفرش کردن مسیر

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isReloading = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // آیکون بالای صفحه
            const Icon(
              Icons.mark_email_read_rounded,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),

            // متن راهنما
            const Text(
              'Confirm your email address',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'A verification link has been sent to:\n${user?.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // دکمه اصلی برای چک کردن وضعیت تایید
            ElevatedButton(
              onPressed: _isReloading
                  ? null
                  : () async {
                      setState(() => _isReloading = true);

                      // ۱. رفرش کردن اطلاعات کاربر از سرور فایربیس
                      await FirebaseAuth.instance.currentUser?.reload();

                      // ۲. گرفتن وضعیت جدید بعد از رفرش
                      final updatedUser = FirebaseAuth.instance.currentUser;

                      if (updatedUser != null && updatedUser.emailVerified) {
                        // ۳. اگر تایید شده بود، پیام موفقیت نشان بده و برو به صفحه اصلی
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email verified! Redirecting...'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // هدایت به AuthGate برای ورود به HomePage
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const AuthGate(),
                            ),
                            (route) => false,
                          );
                        }
                      } else {
                        // ۴. اگر هنوز تایید نشده بود
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Still not verified. Please check your inbox and click the link.',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }

                      if (mounted) setState(() => _isReloading = false);
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isReloading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'I have verified my email',
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 20),

            // دکمه ارسال مجدد ایمیل
            TextButton(
              onPressed: () async {
                await user?.sendEmailVerification();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email resent!')),
                  );
                }
              },
              child: const Text('Resend verification email'),
            ),

            // دکمه خروج و ورود با اکانت دیگر
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text(
                'Login with another account',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
