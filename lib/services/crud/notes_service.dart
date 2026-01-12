import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // استریم نوت‌ها
  Stream<List<Note>> allNotes() {
    return _db
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Note(
              id: doc.id,
              title: data['title'] ?? '',
              content: data['content'] ?? '',
            );
          }).toList(),
        );
  }

  Future<void> addNote(String title, String content) async {
    await _db.collection('notes').add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String id, String title, String content) async {
    await _db.collection('notes').doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _db.collection('notes').doc(id).delete();
  }
}

class Note {
  final String id;
  final String title;
  final String content;

  Note({required this.id, required this.title, required this.content});
}
