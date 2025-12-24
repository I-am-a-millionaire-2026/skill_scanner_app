import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page.dart';

void main() async {
  // 1. اطمینان از مقداردهی اولیه فلاتر
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. جلوگیری هوشمندانه از خطای تکراری فایربیس (حل مشکل صفحه سفید)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app(); // اگر از قبل ساخته شده، از همان استفاده کن
    }
  } catch (e) {
    debugPrint("Firebase catch: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Scanner',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // 3. مطمئن شو که HomePage را در اینجا فراخوانی می‌کنی
      home: const HomePage(),
    );
  }
}
