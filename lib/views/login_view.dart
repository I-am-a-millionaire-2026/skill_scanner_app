import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // اضافه شده
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart'; // اضافه شده
import 'package:skill_scanner/services/auth/bloc/auth_event.dart'; // اضافه شده
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
                final email = _email.text.trim();
                final password = _password.text;

                // 1️⃣ و 2️⃣ ارسال رویداد لاگین به AuthBloc (دستور 10)
                context.read<AuthBloc>().add(AuthEventLogIn(email, password));

                // توجه: مدیریت خطا و جابجایی صفحه اکنون توسط Bloc در main.dart انجام می‌شود
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
