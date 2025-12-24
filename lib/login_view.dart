import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ورود به حساب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'ایمیل')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'رمز عبور')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('ورود'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterView())),
              child: const Text('ساخت حساب جدید'),
            )
          ],
        ),
      ),
    );
  }
}