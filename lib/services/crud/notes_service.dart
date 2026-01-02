import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

// استثناها و ثابت‌ها (بدون تغییر نسبت به قبل برای حفظ پایداری)
class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectory implements Exception {}

class DatabaseIsNotOpen implements Exception {}

class CouldNotDeleteUser implements Exception {}

class UserAlreadyExists implements Exception {}

class CouldNotFindUser implements Exception {}

class CouldNotDeleteNote implements Exception {}

class CouldNotFindNote implements Exception {}

class CouldNotUpdateNote implements Exception {}

const dbName = 'notes.db';
const userTable = 'user';
const notesTable = 'note';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

// مدل‌های داده
@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});
  DatabaseUser.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      email = map[emailColumn] as String;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      userId = map[userIdColumn] as int,
      text = map[textColumn] as String,
      isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1;
}

// --- شروع آپدیت گروه ۳ ---

class NotesService {
  Database? _db;

  // مرحله ۱۱: تعریف لیست کش برای نگهداری نوت‌ها
  List<DatabaseNote> _notes = [];

  // مرحله ۱۵ و ۱۶: پیاده‌سازی الگوی Singleton
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    // مرحله ۱۱: ایجاد StreamController برای اطلاع‌رسانی تغییرات نوت‌ها
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NotesService() => _shared;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  // مرحله ۱۲: Getter برای دسترسی به Stream نوت‌ها از خارج از کلاس
  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  // متد کمکی برای آپدیت کردن کش و Stream (مورد نیاز دستور ۱۱)
  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  // متدهای مدیریت دیتابیس (از گروه ۲ - بدون تغییر در منطق)
  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute('''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "email" TEXT NOT NULL UNIQUE
      );''');

      await db.execute('''CREATE TABLE IF NOT EXISTS "note" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "user_id" INTEGER NOT NULL,
        "text" TEXT,
        "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''');

      // لود کردن اولیه نوت‌ها در کش
      await _cacheNotes();
    } catch (e) {
      throw UnableToGetDocumentsDirectory();
    }
  }

  // سایر متدهای CRUD باید در انتها _cacheNotes() را صدا بزنند تا UI آپدیت شود
  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      final userId = await db.insert(userTable, {
        emailColumn: email.toLowerCase(),
      });
      return DatabaseUser(id: userId, email: email);
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(notesTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpen();
    return db;
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpen();
    await db.close();
    _db = null;
  }
}
