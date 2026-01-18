import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_scanner/services/cloud/cloud_note.dart';
import 'package:skill_scanner/services/cloud/cloud_storage_exceptions.dart';
import 'package:skill_scanner/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  // ایجاد نوت جدید
  Future<CloudNote> createNewNote({
    required String ownerUserId,
    required String text,
  }) async {
    try {
      final documentRef = await _firestore.collection(notesCollection).add({
        ownerUserIdFieldName: ownerUserId,
        textFieldName: text,
        createdAtFieldName: DateTime.now().toIso8601String(),
      });

      final snapshot = await documentRef.get();
      return CloudNote.fromMap(snapshot.data()!, snapshot.id);
    } catch (_) {
      throw CouldNotCreateNoteException();
    }
  }

  // گرفتن نوت‌های یک کاربر
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      final querySnapshot = await _firestore
          .collection(notesCollection)
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get();

      return querySnapshot.docs.map(
        (doc) => CloudNote.fromMap(doc.data(), doc.id),
      );
    } catch (_) {
      throw CouldNotGetAllNotesException();
    }
  }

  // Stream real-time نوت‌های کاربر
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return _firestore
        .collection(notesCollection)
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => CloudNote.fromMap(doc.data(), doc.id)),
        );
  }

  // بروزرسانی نوت
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await _firestore.collection(notesCollection).doc(documentId).update({
        textFieldName: text,
      });
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  // حذف نوت
  Future<void> deleteNote({required String documentId}) async {
    try {
      await _firestore.collection(notesCollection).doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}
