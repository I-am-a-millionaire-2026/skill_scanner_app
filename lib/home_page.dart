import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // این کنترلر برای گرفتن متن از کادر تایپ است
  final TextEditingController _skillController = TextEditingController();

  // لیستی برای ذخیره مهارت‌ها
  List<String> skills = [];

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        skills.add(_skillController.text);
        _skillController.clear(); // پاک کردن کادر بعد از اضافه کردن
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Scanner'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillController,
                    decoration: const InputDecoration(
                      hintText: 'نام مهارت را بنویس...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addSkill,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(skills[index]),
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
