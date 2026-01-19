import 'package:flutter/material.dart';

// دستور ۱۵: تعریف تابع نمایش دیالوگ لودینگ
typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(text),
      ],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false, // جلوگیری از بستن دیالوگ توسط کاربر
    builder: (context) => dialog,
  );

  // تابعی برای بستن دیالوگ از درون لیسنر
  return () => Navigator.of(context).pop();
}
