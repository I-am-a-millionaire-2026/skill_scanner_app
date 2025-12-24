import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تایید ایمیل')),
      body: Column(
        children: [
          const Text('لطفاً ایمیل خود را چک کرده و روی لینک تایید کلیک کنید.'),
          ElevatedButton(
            onPressed: () => FirebaseAuth.instance.currentUser?.reload(),
            child: const Text('تایید کردم'),
          ),
          TextButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }
}
