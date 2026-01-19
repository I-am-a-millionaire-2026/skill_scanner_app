import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';

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
            TextButton(
              onPressed: () {
                // دستور ۲۵: ارسال ایونت ارسال مجدد ایمیل به Bloc
                context.read<AuthBloc>().add(
                  const AuthEventSendEmailVerification(),
                );
              },
              child: const Text('Resend verification email'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // دستور ۲۶: ارسال ایونت LogOut برای شروع مجدد فرآیند
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
