import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UnableToGetDocumentsDirectory implements Exception {}

class NotesService {
  Database? _db;
  List<DatabaseNote> _notes = [];

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NotesService() => _shared;

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<void> open() async {
    if (_db != null) return;
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, 'notes.db');
      final db = await openDatabase(dbPath);
      _db = db;
      await _cacheNotes();
    } catch (e) {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  // متدهای CRUD که در NewNoteView استفاده می‌شوند
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final note = DatabaseNote(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: owner.id,
      text: '',
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final updatedNote = DatabaseNote(
      id: note.id,
      userId: note.userId,
      text: text,
    );
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      _notesStreamController.add(_notes);
    }
    return updatedNote;
  }

  Future<void> deleteNote({required int id}) async {
    _notes.removeWhere((note) => note.id == id);
    _notesStreamController.add(_notes);
  }

  Future<List<DatabaseNote>> getAllNotes() async => _notes;
  Future<DatabaseUser> getOrCreateUser({required String email}) async =>
      DatabaseUser(id: 1, email: email);
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
  });
}
