import 'package:flutter/foundation.dart';

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
      ownerUserId = map['ownerUserId'] as String,
      text = map['text'] as String,
      createdAt = DateTime.parse(map['createdAt'] as String);

  Map<String, dynamic> toMap() {
    return {
      'ownerUserId': ownerUserId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
