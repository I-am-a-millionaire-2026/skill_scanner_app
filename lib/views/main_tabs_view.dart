import 'package:flutter/material.dart';

class MainTabsView extends StatelessWidget {
  const MainTabsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Dashboard'), centerTitle: true),
      body: const Center(child: Text('خوش آمدید! این صفحه اصلی اپلیکیشن است.')),
    );
  }
}
