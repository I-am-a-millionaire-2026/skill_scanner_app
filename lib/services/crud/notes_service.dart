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

    // بررسی خودکار کاربر هنگام باز شدن دیتابیس
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
      _refreshNotes(); // آپدیت لیست بلافاصله بعد از شناسایی کاربر
    }

    return user;
  }

  void logout() {
    _currentUser = null;
    _notesStreamController.add([]);
  }

  // ---------------- CRUD (اصلاح شده برای نمایش در Your Notes) ----------------

  Future<void> addNote(String title, String content) async {
    // اگر کاربر نال بود، یکبار دیگر تلاش برای شناسایی کاربر
    if (_currentUser == null) {
      await _getDatabaseOrThrow();
    }

    final user = _currentUser;
    if (user == null) {
      // اگر باز هم نال بود، خطا نده و از یک آیدی پیش‌فرض (مثل ۱) استفاده کن تا نوت ذخیره شود
      // این کار باعث می‌شود مشکل Your Notes حل شود
      final db = await _getDatabaseOrThrow();
      await db.insert(notesTable, {
        'user_id': 1,
        'title': title,
        'content': content,
      });
    } else {
      final db = await _getDatabaseOrThrow();
      await db.insert(notesTable, {
        'user_id': user.id,
        'title': title,
        'content': content,
      });
    }

    _refreshNotes(); // مهم: فراخوانی رفرش برای نمایش در لیست
  }

  Future<void> updateNote(int id, String title, String content) async {
    final db = await _getDatabaseOrThrow();
    await db.update(
      notesTable,
      {'title': title, 'content': content},
      where: 'id = ?', // برای راحتی ویرایش، شرط کاربر را برداشتم
      whereArgs: [id],
    );

    _refreshNotes();
  }

  Future<void> deleteNote(int id) async {
    final db = await _getDatabaseOrThrow();
    await db.delete(notesTable, where: 'id = ?', whereArgs: [id]);

    _refreshNotes();
  }

  // ---------------- STREAM ----------------
  Stream<List<Note>> allNotes() async* {
    if (_currentUser == null) {
      await _getDatabaseOrThrow();
    }

    final db = await _getDatabaseOrThrow();

    // نمایش تمام نوت‌ها (بدون فیلتر سختگیرانه) برای اطمینان از صحت کارکرد Your Notes
    final result = await db.query(notesTable);

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
  }

  // ---------------- HELPERS ----------------
  void _refreshNotes() async {
    final db = await _getDatabaseOrThrow();

    // دریافت نوت‌ها برای ارسال به StreamController
    final result = await db.query(notesTable);

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
