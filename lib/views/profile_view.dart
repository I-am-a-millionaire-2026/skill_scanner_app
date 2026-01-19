import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/utilities/dialogs/logout_dialog.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Scanner'),
        actions: [
          // دکمه خروج از حساب کاربری - مطابق با مرحله ۱ دستورات جدید
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                // استفاده از Bloc به جای FirebaseAuth.instance.signOut مستقیم
                if (context.mounted) {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // بخش هدر پروفایل (حفظ شده از کدهای قبلی شما)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
              ),
            ),
            const Text(
              'Sara Kasraie',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // لیست فعالیت‌ها (حفظ شده از کدهای قبلی شما)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Activity #$index'),
                    subtitle: const Text('Recent Tech Insight'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// تابع نمایش دیالوگ تایید خروج (حفظ شده از کدهای قبلی شما)
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('خروج'),
        content: const Text('آیا مطمئن هستید که می‌خواهید خارج شوید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('خروج'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
