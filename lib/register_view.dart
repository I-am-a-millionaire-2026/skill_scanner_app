import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // کنترلرها برای گرفتن متن از فیلدها
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool _isLoading = false;

  // تابع نمایش پیام به کاربر
  void showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // تابع اصلی ثبت‌نام
  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmController.text.trim();

    // بررسی خالی نبودن فیلدها
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    // بررسی تطابق رمز عبور
    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ۱. ایجاد حساب کاربری در فایربیس
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ۲. آپدیت کردن نام کاربر (DisplayName)
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      // ۳. ارسال ایمیل تایید (Email Verification)
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      showMessage('Account created! Please check your email for verification.');

      // ۴. بازگشت به صفحه قبل (AuthGate در main.dart بقیه کار را انجام می‌دهد)
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // مدیریت خطاهای احتمالی فایربیس
      if (e.code == 'weak-password') {
        showMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showMessage('The account already exists for that email.');
      } else {
        showMessage(e.message ?? 'An error occurred');
      }
    } catch (e) {
      showMessage('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // بستن کنترلرها برای جلوگیری از مصرف حافظه
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // فیلد نام کامل
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                // فیلد ایمیل
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                // فیلد رمز عبور
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 15),
                // فیلد تایید رمز عبور
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Confirm your password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_clock),
                  ),
                ),
                const SizedBox(height: 30),
                // دکمه ثبت‌نام
                ElevatedButton(
                  onPressed: _isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Register', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
          // نمایش دایره در حال انتظار
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
