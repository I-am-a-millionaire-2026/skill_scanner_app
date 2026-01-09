import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';

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
            const Text('Please check your email to verify your account.'),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Resend verification email'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
