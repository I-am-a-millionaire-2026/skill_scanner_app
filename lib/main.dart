import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/helpers/loading/loading_screen.dart';
import 'package:skill_scanner/services/auth/firebase_auth_provider.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/services/auth/bloc/auth_state.dart';
import 'package:skill_scanner/services/cloud/cloud_note.dart'; // ایمپورت کلاس MasterCard
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/notes/create_update_note_view.dart';
import 'package:skill_scanner/views/forgot_password_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- دستور شماره 9: Mock Data Test ---
  // ایجاد یک شیء نمونه برای اطمینان از سلامت مدل جدید
  final testCard = MasterCard(
    documentId: 'test-id-123',
    ownerUserId: 'user-001',
    text: 'Learn how to master AI prompting',
    tools: ['ChatGPT', 'Gemini'],
    steps: ['Open App', 'Type Prompt', 'Optimize'],
    estimatedTime: '15 min',
    level: 'Advanced',
    createdAt: DateTime.now(),
  );

  // پرینت در کنسول برای تایید مدل (اطمینان از سلامت قبل از دیتابیس)
  debugPrint('--- Model Test Results ---');
  debugPrint('Title/Text: ${testCard.text}');
  debugPrint('Tools List: ${testCard.tools}');
  debugPrint('Complexity Level: ${testCard.level}');
  debugPrint('-------------------------');
  // --- پایان دستور شماره 9 ---

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
      home: const HomePage(),
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
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
