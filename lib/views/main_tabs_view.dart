import 'package:flutter/material.dart';
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/notes/create_update_note_view.dart';

class MainTabsView extends StatefulWidget {
  const MainTabsView({Key? key}) : super(key: key);

  @override
  State<MainTabsView> createState() => _MainTabsViewState();
}

class _MainTabsViewState extends State<MainTabsView> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [NotesView(), CreateUpdateNoteView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New'),
        ],
      ),
    );
  }
}
