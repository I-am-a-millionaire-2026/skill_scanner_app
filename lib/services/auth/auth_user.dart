import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String email;
  final bool isEmailVerified;

  // مرحله ۱۱: ساختار را Required کردیم تا در تست‌ها و ساخت مدل ابهامی نباشد
  const AuthUser({required this.email, required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(email: user.email ?? '', isEmailVerified: user.emailVerified);
}
