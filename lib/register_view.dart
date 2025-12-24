import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت‌نام')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: email, decoration: const InputDecoration(labelText: 'ایمیل')),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'رمز عبور')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email.text.trim(),
                    password: password.text.trim(),
                  );
                  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('تایید و ارسال ایمیل فعال‌سازی'),
            ),
          ],
        ),
      ),
    );
  }
}