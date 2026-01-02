import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String email; // مرحله ۲: اضافه شدن فیلد ایمیل
  final bool isEmailVerified;

  const AuthUser({required this.email, required this.isEmailVerified});

  // مرحله ۱: متدی که کاربر فایربیس را به کاربر مدل ما تبدیل می‌کند
  factory AuthUser.fromFirebase(User user) => AuthUser(
    email: user.email!, // گرفتن ایمیل از فایربیس
    isEmailVerified: user.emailVerified,
  );
}
