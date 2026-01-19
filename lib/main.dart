import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/services/auth/firebase_auth_provider.dart';
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
    // تزریق AuthBloc به کل برنامه
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // نقطه شروع برنامه HomePage است
      home: const HomePage(),
      // دستور ۳۶: حذف مسیرهای اضافی و نگه داشتن مسیر نوت
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // مقداردهی اولیه احراز هویت در شروع برنامه
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          // کاربر لاگین است -> نمایش یور نوت
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          // نیاز به تایید ایمیل
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          // دستور ۳۴: کاربر خارج شده یا خطایی رخ داده -> نمایش صفحه لاگین
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          // دستور ۳۷: نمایش صفحه ثبت‌نام بر اساس وضعیت بلوک
          return const RegisterView();
        } else {
          // وضعیت در حال بارگذاری اولیه
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
