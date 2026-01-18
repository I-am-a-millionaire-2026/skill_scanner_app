import 'package:flutter/foundation.dart';
import 'package:skill_scanner/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final DateTime createdAt;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.createdAt,
  });

  CloudNote.fromMap(Map<String, dynamic> map, String documentId)
    : documentId = documentId,
      ownerUserId = map[ownerUserIdFieldName] as String,
      text = map[textFieldName] as String,
      createdAt = DateTime.parse(map[createdAtFieldName] as String);

  Map<String, dynamic> toMap() {
    return {
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
      createdAtFieldName: createdAt.toIso8601String(),
    };
  }
}
