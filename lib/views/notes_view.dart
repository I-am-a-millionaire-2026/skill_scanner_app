import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_scanner/constants/routes.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // گرفتن اطلاعات کاربر فعلی از فایربیس
  String get userName =>
      FirebaseAuth.instance.currentUser?.displayName ?? 'User';
  String get userEmail =>
      FirebaseAuth.instance.currentUser?.email ?? 'No Email';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Master Me Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          // دکمه خروج (Logout)
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
              }
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بخش خوش‌آمدگویی با نام کاربر
            Text(
              'Welcome back,',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Your Skill Progress',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // لیست مهارت‌ها (به صورت کارت‌های زیبا)
            Expanded(
              child: ListView(
                children: [
                  _buildSkillItem('Flutter Development', 0.85, Colors.blue),
                  _buildSkillItem('Firebase Architecture', 0.70, Colors.orange),
                  _buildSkillItem('UI/UX Design', 0.55, Colors.purple),
                  _buildSkillItem('AI Integration', 0.30, Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
      // دکمه شناور برای اسکن جدید
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // اینجا کد باز شدن دوربین یا اسکنر رو بعداً مینویسیم
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: const Text('New Scan', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // ویجت کمکی برای ساخت کارت‌های مهارت
  Widget _buildSkillItem(String title, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}

// دیالوگ تایید خروج
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
