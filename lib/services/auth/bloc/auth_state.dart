import 'package:flutter/foundation.dart' show immutable;
import 'package:skill_scanner/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

// وضعیت لودینگ کلی
class AuthStateLoading extends AuthState {
  const AuthStateLoading() : super(isLoading: true);
}

// وضعیت ورود موفق
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user) : super(isLoading: false);
}

// وضعیت نیاز به تایید ایمیل
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification() : super(isLoading: false);
}

// وضعیت خارج شده (ترکیب شده با مدیریت خطا طبق دستور 1)
class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception, required bool isLoading})
    : super(isLoading: isLoading);
}
