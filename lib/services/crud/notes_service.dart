import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final StreamController<List<Note>> _notesStreamController =
      StreamController<List<Note>>.broadcast();

  Stream<List<Note>> get notesStream => _notesStreamController.stream;

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

    // وقتی دیتابیس باز شد، currentUser رو با FirebaseAuth مقداردهی کن
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null && firebaseUser.email != null) {
      await getOrCreateUser(email: firebaseUser.email!);
    }

    return _db!;
  }

  // ---------------- USER ----------------
  Future<DatabaseUser> getOrCreateUser({
    required String email,
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
      _refreshNotes(); // آپدیت فوری نوت‌ها برای Stream
    }

    return user;
  }

  void logout() {
    _currentUser = null;
    _notesStreamController.add([]);
  }

  // ---------------- CRUD ----------------

  Future<void> addNote(String title, String content) async {
    if (_currentUser == null) {
      // شناسایی کاربر با FirebaseAuth در صورت null بودن
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null || firebaseUser.email == null) {
        throw Exception('User not logged in');
      }
      await getOrCreateUser(email: firebaseUser.email!);
    }

    final db = await _getDatabaseOrThrow();
    await db.insert(notesTable, {
      'user_id': _currentUser!.id,
      'title': title,
      'content': content,
    });

    _refreshNotes();
  }

  Future<void> updateNote(int id, String title, String content) async {
    final db = await _getDatabaseOrThrow();
    await db.update(
      notesTable,
      {'title': title, 'content': content},
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, _currentUser!.id],
    );
    _refreshNotes();
  }

  Future<void> deleteNote(int id) async {
    final db = await _getDatabaseOrThrow();
    await db.delete(
      notesTable,
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, _currentUser!.id],
    );
    _refreshNotes();
  }

  // ---------------- STREAM ----------------
  Stream<List<Note>> allNotes() async* {
    if (_currentUser == null) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null || firebaseUser.email == null) {
        yield [];
        return;
      }
      await getOrCreateUser(email: firebaseUser.email!);
    }

    final db = await _getDatabaseOrThrow();
    final result = await db.query(
      notesTable,
      where: 'user_id = ?',
      whereArgs: [_currentUser!.id],
    );

    final notes = result
        .map(
          (row) => Note(
            id: row['id'] as int,
            title: row['title'] as String? ?? '',
            content: row['content'] as String? ?? '',
            userId: row['user_id'] as int,
          ),
        )
        .toList();

    yield notes;

    // ارسال داده‌ها به StreamController برای real-time UI
    _notesStreamController.add(notes);
  }

  // ---------------- HELPERS ----------------
  void _refreshNotes() async {
    if (_currentUser == null) return;

    final db = await _getDatabaseOrThrow();
    final result = await db.query(
      notesTable,
      where: 'user_id = ?',
      whereArgs: [_currentUser!.id],
    );

    final notes = result
        .map(
          (row) => Note(
            id: row['id'] as int,
            title: row['title'] as String? ?? '',
            content: row['content'] as String? ?? '',
            userId: row['user_id'] as int,
          ),
        )
        .toList();

    _notesStreamController.add(notes);
  }
}
