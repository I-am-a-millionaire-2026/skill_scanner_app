import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_bloc.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Scanner'),
        actions: [
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
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
            // ✅ دستور شماره ۵: اضافه کردن Attribution جهت رعایت کپی‌رایت
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'App Icon by Filo from www.stockio.com',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// تابع دیالوگ خروج (بدون تغییر)
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
