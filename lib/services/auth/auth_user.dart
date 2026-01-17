import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id; // ✅ UID
  final String email; // ✅ دیگر optional نیست
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
    id: user.uid, // ✅ گرفتن UID
    email: user.email!, // ایمیل اجباری
    isEmailVerified: user.emailVerified,
  );
}
