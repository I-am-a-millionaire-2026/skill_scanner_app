import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/services/auth/auth_exceptions.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/services/auth/bloc/auth_state.dart';
import 'package:skill_scanner/utilities/dialogs/error_dialog.dart';
import 'package:skill_scanner/utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.isLoading) {
          _closeDialogHandle = showLoadingDialog(
            context: context,
            text: state.loadingText ?? 'Please wait...',
          );
        } else {
          _closeDialogHandle?.call();
          _closeDialogHandle = null;
        }

        if (state is AuthStateLoggedOut) {
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
              TextButton(
                onPressed: () async {
                  final email = _email.text.trim();
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  // دستور ۳۷: فقط ایونت تغییر وضعیت را می‌فرستیم
                  // BlocBuilder در main.dart به صورت خودکار RegisterView را نشان می‌دهد
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
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
