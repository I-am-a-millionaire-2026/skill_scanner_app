import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable // برای امنیت بیشتر داده‌ها
class AuthUser {
  final bool isEmailVerified;
  final String email;

  const AuthUser({required this.email, required this.isEmailVerified});

  // Factory initializer برای تبدیل مستقیم کاربر فایربیس به مدل ما
  factory AuthUser.fromFirebase(User user) =>
      AuthUser(email: user.email ?? '', isEmailVerified: user.emailVerified);
}
