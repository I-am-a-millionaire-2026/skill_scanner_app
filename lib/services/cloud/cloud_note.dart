import 'package:flutter/foundation.dart';
import 'package:skill_scanner/services/cloud/cloud_storage_constants.dart';

@immutable
class MasterCard {
  final String documentId;
  final String ownerUserId;
  final String text;
  final List<String> tools;
  final List<String> steps;
  final String estimatedTime;
  final String level;
  final DateTime createdAt;

  const MasterCard({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.tools,
    required this.steps,
    required this.estimatedTime,
    required this.level,
    required this.createdAt,
  });

  // --- اجرای دقیق دستور شماره 7: بازنویسی متد خواندن (From Map) ---
  MasterCard.fromMap(Map<String, dynamic> map, String documentId)
    : documentId = documentId,
      ownerUserId = map[ownerUserIdFieldName] as String,
      text = map[textFieldName] as String,
      // تبدیل لیست‌های dynamic دیتابیس به List<String> برای فلاتر
      tools = (map[toolsFieldName] as List<dynamic>?)?.cast<String>() ?? [],
      steps = (map[stepsFieldName] as List<dynamic>?)?.cast<String>() ?? [],
      estimatedTime = map[estimatedTimeFieldName] as String? ?? '',
      level = map[levelFieldName] as String? ?? 'Beginner',
      createdAt = DateTime.parse(map[createdAtFieldName] as String);

  // --- اجرای دقیق دستور شماره 7: بازنویسی متد نوشتن (To Map) ---
  Map<String, dynamic> toMap() {
    return {
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
      // تبدیل لیست‌ها به فرمت قابل ذخیره در فایربیس (JSON Serialization)
      toolsFieldName: tools,
      stepsFieldName: steps,
      estimatedTimeFieldName: estimatedTime,
      levelFieldName: level,
      createdAtFieldName: createdAt.toIso8601String(),
    };
  }
}
