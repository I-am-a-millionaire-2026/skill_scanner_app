import 'package:flutter/material.dart';

// دستور شماره 10: دیالوگ تایید ارسال ایمیل بازیابی رمز
Future<void> showPasswordResetDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Password Reset Sent'),
        content: const Text(
          'We have now sent you a password reset link. Please check your email for more information.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
