import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_scanner/constants/routes.dart';
// وارد کردن فایل جدید برای نمایش دیالوگ‌ها
import 'package:skill_scanner/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isLoading = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration('Email', Icons.email),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration('Password', Icons.lock),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleForgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                  },
                  child: const Text(
                    'New here? Create Account',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon, color: Colors.blueAccent),
    );
  }

  Future<void> _login() async {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || password.isEmpty) {
      await showErrorDialog(context, 'Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      _handleError(e.code, e.message);
    } catch (e) {
      _handleError('unknown-error', e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      await showErrorDialog(context, 'Please enter your email address first.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        await showSuccessDialog(
          context,
          'Password reset link sent to your email.',
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleError(e.code, e.message);
    } catch (e) {
      _handleError('unknown-error', e.toString());
    }
  }

  void _handleError(String code, String? technicalMessage) {
    String displayMessage;
    switch (code) {
      case 'user-not-found':
        displayMessage = 'No user found with this email.';
        break;
      case 'wrong-password':
        displayMessage = 'The password you entered is incorrect.';
        break;
      case 'invalid-credential':
        displayMessage = 'Invalid email or password credentials.';
        break;
      case 'network-request-failed':
        displayMessage = 'Please check your internet connection.';
        break;
      default:
        displayMessage =
            technicalMessage ?? 'An unexpected error occurred ($code).';
    }
    if (mounted) {
      showErrorDialog(context, displayMessage);
    }
  }
}
