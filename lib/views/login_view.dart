import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/auth_exceptions.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/services/auth/bloc/auth_state.dart';
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
    // 5️⃣ & 8️⃣ استفاده از Listener برای تست رفتار برنامه و نمایش خطاها
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          // 6️⃣ & 8️⃣ بررسی انواع Exception برای اطمینان از صحت معماری در تست
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
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
              // 7️⃣ دکمه فقط Event ارسال می‌کند تا معماری در تست شماره 8 قابل ارزیابی باشد
              TextButton(
                onPressed: () async {
                  final email = _email.text.trim();
                  final password = _password.text;
                  // Dispatch کردن رویداد بدون منطق اضافی در UI
                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
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
      ),
    );
  }
}
