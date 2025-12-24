import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // چک کردن اینکه آیا کاربر لاگین هست یا نه
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Scanner'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, // سفید کردن متن و دکمه‌های AppBar
        actions: [
          // 🔹 دکمه SCAN (CTA اصلی)
          TextButton(
            onPressed: () {
              debugPrint('SCAN Button Clicked');
              // اینجا می‌توانید کد باز کردن دوربین یا اسکنر را قرار دهید
            },
            child: const Text(
              'SCAN',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // 🔹 دکمه ورود/خروج
          IconButton(
            icon: Icon(user == null ? Icons.login : Icons.logout),
            onPressed: () async {
              if (user == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              } else {
                await FirebaseAuth.instance.signOut();
                // ری‌استارت کردن صفحه برای تغییر وضعیت آیکون
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Skill Scanner',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start scanning to discover skills',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // 🔹 دکمه Get Started در وسط صفحه
            ElevatedButton(
              onPressed: () {
                debugPrint('Get Started Clicked');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Get Started', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
