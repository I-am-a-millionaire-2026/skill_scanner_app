// cannot_share_empty_note_dialog.dart
import 'package:flutter/material.dart';
import 'package:skill_scanner/utilities/dialogs/generic_dialog.dart';

// ✅ دستور شماره 6: پیاده‌سازی دیالوگ هشدار به صورت Async
Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note!', // ✅ پیام اطلاع‌رسانی به کاربر
    optionsBuilder: () => {'OK': null},
  );
}
