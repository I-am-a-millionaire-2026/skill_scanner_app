import 'package:flutter/material.dart';
import 'package:skill_scanner/views/notes/notes_view.dart'; // مسیر جدید اصلاح شد

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Welcome to Home Page', style: TextStyle(fontSize: 18)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotesView()),
          );
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
