import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A verification email has been sent. Please check your inbox and click the link. Then, press the button below.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.reload();
                if (user?.emailVerified ?? false) {
                  if (mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(notesRoute, (r) => false);
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email not verified yet.')),
                    );
                  }
                }
              },
              child: const Text('I have verified'),
            ),
            TextButton(
              onPressed: _isSending
                  ? null
                  : () async {
                      setState(() => _isSending = true);
                      await FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                      setState(() => _isSending = false);
                    },
              child: const Text('Resend verification email'),
            ),
          ],
        ),
      ),
    );
  }
}
