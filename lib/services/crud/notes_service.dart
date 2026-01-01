import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'crud_exceptions.dart';

// --- ثابت‌های دیتابیس (Constants) ---
const dbName = 'notes.db';
const userTable = 'user';
const noteTable = 'note';
const idColumn = 'id';
const emailColumn = 'email';
const nameColumn = 'name';
const passwordColumn = 'password';
const isEmailVerifiedColumn = 'is_email_verified';
const userIdColumn = 'user_id';
const textColumn = 'text';

class NotesService {
  Database? _db;

  // --- متدهای زیرساختی (Infrastructure) ---

  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = p.join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) throw Exception('Database not open');
    await db.close();
    _db = null;
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw Exception('Database not open');
    return db;
  }

  // --- متدهای CRUD کاربر (Users) ---

  // ۲۰. ایجاد کاربر (createUser)
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) throw UserAlreadyExistsException();

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);
  }

  // ۲۱. دریافت کاربر (getUser)
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) throw CouldNotFindUserException();
    return DatabaseUser.fromRow(results.first);
  }

  // ۱۹. حذف کاربر (deleteUser)
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) throw CouldNotDeleteUserException();
  }

  // --- متدهای CRUD یادداشت‌ها (Notes) ---

  // ۲۲. ایجاد یادداشت (createNote)
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    // تایید وجود کاربر در دیتابیس
    await getUser(email: owner.email);

    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: '',
    });

    return DatabaseNote(id: noteId, userId: owner.id, text: '');
  }

  // ۲۳. حذف یک یادداشت (deleteNote)
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) throw CouldNotFindNoteException();
  }

  // ۲۴. حذف تمام یادداشت‌ها (deleteAllNotes)
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  // ۲۵. دریافت یک یادداشت خاص (getNote)
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) throw CouldNotFindNoteException();
    return DatabaseNote.fromRow(notes.first);
  }

  // ۲۶. دریافت تمام یادداشت‌ها (getAllNotes)
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((row) => DatabaseNote.fromRow(row));
  }

  // ۲۷. بروزرسانی یادداشت (updateNote)
  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    // اطمینان از وجود یادداشت
    await getNote(id: note.id);

    final updatesCount = await db.update(
      noteTable,
      {textColumn: text},
      where: 'id = ?',
      whereArgs: [note.id],
    );

    if (updatesCount == 0) throw CouldNotUpdateNoteException();
    return await getNote(id: note.id);
  }

  // --- دستورات SQL ---
  static const createUserTable =
      '''
    CREATE TABLE IF NOT EXISTS "$userTable" (
      "$idColumn" INTEGER PRIMARY KEY AUTOINCREMENT,
      "$emailColumn" TEXT NOT NULL UNIQUE
    );
  ''';

  static const createNoteTable =
      '''
    CREATE TABLE IF NOT EXISTS "$noteTable" (
      "$idColumn" INTEGER PRIMARY KEY AUTOINCREMENT,
      "$userIdColumn" INTEGER NOT NULL,
      "$textColumn" TEXT,
      FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$idColumn")
    );
  ''';
}

// --- مدل‌های داده (Models) ---

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  DatabaseNote({required this.id, required this.userId, required this.text});

  DatabaseNote.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      userId = map[userIdColumn] as int,
      text = map[textColumn] as String;

  @override
  String toString() => 'Note, ID = $id, userId = $userId, text = $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
