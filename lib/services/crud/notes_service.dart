import 'dart:async';

class NotesService {
  final List<String> _notes = [];
  final StreamController<List<String>> _notesController =
      StreamController.broadcast();

  Stream<List<String>> allNotesStream() {
    _notesController.add(_notes);
    return _notesController.stream;
  }

  Future<void> addNote(String text) async {
    _notes.add(text);
    _notesController.add(_notes);
  }
}
