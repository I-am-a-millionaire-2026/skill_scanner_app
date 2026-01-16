import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'crud_exceptions.dart';

const notesTable = 'notes';
const usersTable = 'users';

class Note {
  final int id;
  final String title;
  final String content;
  final int userId;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });
}

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});
}

class NotesService {
  Database? _db;
  DatabaseUser? _currentUser;

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  // ---------------- DATABASE ----------------
  Future<Database> _getDatabaseOrThrow() async {
    if (_db != null) return _db!;

    _db = await openDatabase(
      'notes.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $usersTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL UNIQUE
          );
        ''');

        await db.execute('''
          CREATE TABLE $notesTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT,
            content TEXT,
            FOREIGN KEY (user_id) REFERENCES $usersTable(id)
          );
        ''');
      },
    );

    return _db!;
  }

  // ---------------- USER ----------------
  Future<DatabaseUser> getOrCreateUser(
    String email, {
    bool setAsCurrentUser = true,
  }) async {
    final db = await _getDatabaseOrThrow();

    final result = await db.query(
      usersTable,
      where: 'email = ?',
      whereArgs: [email],
    );

    late final DatabaseUser user;

    if (result.isEmpty) {
      final id = await db.insert(usersTable, {'email': email});
      user = DatabaseUser(id: id, email: email);
    } else {
      user = DatabaseUser(
        id: result.first['id'] as int,
        email: result.first['email'] as String,
      );
    }

    if (setAsCurrentUser) {
      _currentUser = user;
    }

    return user;
  }

  void logout() {
    _currentUser = null;
  }

  // ---------------- CRUD ----------------
  Future<void> addNote(String title, String content) async {
    final user = _currentUser;
    if (user == null) {
      throw const UserShouldBeSetBeforeReadingAllNotes();
    }

    final db = await _getDatabaseOrThrow();
    await db.insert(notesTable, {
      'user_id': user.id,
      'title': title,
      'content': content,
    });
  }

  Future<void> updateNote(int id, String title, String content) async {
    final db = await _getDatabaseOrThrow();

    // ✅ فقط نوت مشخص با id آپدیت شود
    await db.update(
      notesTable,
      {'title': title, 'content': content},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await _getDatabaseOrThrow();
    await db.delete(notesTable, where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- STREAM ALL NOTES ----------------
  Stream<List<Note>> allNotes() async* {
    final user = _currentUser;
    if (user == null) {
      throw const UserShouldBeSetBeforeReadingAllNotes();
    }

    final db = await _getDatabaseOrThrow();

    // همه نوت‌ها از DB
    final result = await db.query(notesTable);

    final allNotes = result
        .map(
          (row) => Note(
            id: row['id'] as int,
            title: row['title'] as String? ?? '',
            content: row['content'] as String? ?? '',
            userId: row['user_id'] as int,
          ),
        )
        .toList();

    // ✅ فیلتر نوت‌های کاربر فعلی
    yield allNotes.where((note) => note.userId == user.id).toList();
  }
}
