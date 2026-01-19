import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/firebase_auth_provider.dart'; // اضافه شده برای رفع خطا
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/services/auth/bloc/auth_state.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/notes/create_update_note_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('[core/duplicate-app]')) {
      debugPrint('Firebase app already initialized');
    } else {
      rethrow;
    }
  }

  runApp(
    // 1️⃣ تزریق AuthBloc به سراسر برنامه با استفاده از پرووایدری که خطا ندهد (بند 9)
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      // 2️⃣ استفاده از HomePage به عنوان نقطه ورود برای مدیریت وضعیت‌ها توسط BlocBuilder
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ارسال رویداد اولیه برای بررسی وضعیت لاگین کاربر به محض اجرای برنامه
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          // ✅ پایداری: اگر کاربر لاگین است، مستقیماً نوت‌ها را ببیند
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          // اگر ایمیل تایید نشده است
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          // اگر خارج شده است، صفحه لاگین نمایش داده شود
          return const LoginView();
        } else {
          // در وضعیت Loading، یک Spinner نمایش داده می‌شود
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
