import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_scanner/services/cloud/cloud_note.dart'; // کلاس MasterCard در اینجا تعریف شده
import 'package:skill_scanner/services/cloud/cloud_storage_exceptions.dart';
import 'package:skill_scanner/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  // ایجاد کارت جدید (جایگزین createNewNote)
  Future<MasterCard> createNewNote({
    required String ownerUserId,
    required String text,
  }) async {
    try {
      final documentRef = await _firestore
          .collection(masterCardsCollection)
          .add({
            ownerUserIdFieldName: ownerUserId,
            textFieldName: text,
            toolsFieldName: [],
            stepsFieldName: [],
            estimatedTimeFieldName: '5 min',
            levelFieldName: 'Beginner',
            createdAtFieldName: DateTime.now().toIso8601String(),
          });

      final snapshot = await documentRef.get();
      return MasterCard.fromMap(snapshot.data()!, snapshot.id);
    } catch (_) {
      throw CouldNotCreateNoteException();
    }
  }

  // نمایش تمام کارت‌ها
  Stream<Iterable<MasterCard>> allNotes({required String ownerUserId}) {
    return _firestore
        .collection(masterCardsCollection) // اصلاح نام کلکسیون
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) => MasterCard.fromMap(doc.data(), doc.id),
          ),
        );
  }

  // بروزرسانی کارت
  Future<void> updateNote({
    required String documentId,
    String? text,
    List<String>? tools,
    List<String>? steps,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (text != null) updates[textFieldName] = text;
      if (tools != null) updates[toolsFieldName] = tools;
      if (steps != null) updates[stepsFieldName] = steps;

      await _firestore
          .collection(masterCardsCollection)
          .doc(documentId)
          .update(updates);
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  // حذف کارت
  Future<void> deleteNote({required String documentId}) async {
    try {
      await _firestore
          .collection(masterCardsCollection)
          .doc(documentId)
          .delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}
