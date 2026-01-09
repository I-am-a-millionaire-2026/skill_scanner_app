import 'package:flutter/material.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_service.dart';
import 'package:skill_scanner/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
            ),
            TextButton(
              onPressed: () async {
                // .trim() باعث حذف فاصله‌های اضافی (Space) می‌شود که در لاگ شما خطا می‌داد
                final email = _email.text.trim();
                final password = _password.text;

                try {
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );

                  final user = AuthService.firebase().currentUser;

                  if (mounted) {
                    if (user?.isEmailVerified ?? false) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );
                    }
                  }
                } catch (e) {
                  // حالا اگر خطایی رخ دهد (مثل پسورد غلط)، آن را روی گوشی می‌بینی
                  if (mounted) {
                    await showErrorDialog(context, e.toString());
                  }
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here!'),
            ),
          ],
        ),
      ),
    );
  }
}
