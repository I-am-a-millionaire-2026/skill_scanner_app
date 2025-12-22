import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // کنترلرها برای دریافت اطلاعات از کاربر
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // تابع نمایش پیام (SnackBar)
  void showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // تابع اصلی ثبت نام
  Future signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    // ۱. بررسی خالی نبودن فیلدها
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    // ۲. بررسی تطابق رمز عبور
    if (password != confirm) {
      showMessage('Passwords do not match!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ۳. ایجاد حساب کاربری در فایربیس
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ۴. ذخیره نام کاربر در پروفایل فایربیس (برای نمایش در HomePage)
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      // ۵. ارسال لینک تأیید ایمیل (Email Verification)
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      showMessage('Account created! Please verify your email.');

      // ۶. بازگشت به صفحه قبل
      // چون AuthGate در main.dart داریم، اپلیکیشن خودکار به صفحه VerifyEmailView می‌رود
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // مدیریت خطاهای فایربیس
      if (e.code == 'weak-password') {
        showMessage('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showMessage('An account already exists for this email.');
      } else {
        showMessage(e.message ?? 'An error occurred');
      }
    } catch (e) {
      showMessage('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // پاکسازی کنترلرها برای جلوگیری از نشت حافظه
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register to Skill Scanner')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // فیلد نام کامل
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 15),
                // فیلد ایمیل
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 15),
                // فیلد رمز عبور
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 15),
                // فیلد تایید رمز عبور
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_reset),
                  ),
                ),
                const SizedBox(height: 30),
                // دکمه ثبت نام
                ElevatedButton(
                  onPressed: _isLoading ? null : signUp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Register Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                // دکمه بازگشت به لاگین
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
          // نمایش لودینگ در هنگام ثبت نام
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
