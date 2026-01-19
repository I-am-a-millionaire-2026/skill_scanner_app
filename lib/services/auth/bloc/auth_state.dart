import 'package:flutter/foundation.dart' show immutable;
import 'package:skill_scanner/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

// 1️⃣ Loading State: نشان‌دهنده در حال بارگذاری بودن (مثلاً موقع زدن دکمه لاگین)
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

// 2️⃣ LoggedIn State: کاربر با موفقیت وارد شده است
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

// 3️⃣ NeedsVerification State: کاربر وارد شده اما ایمیلش هنوز تایید نشده است
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

// 4️⃣ LoggedOut State: کاربر خارج شده است (همراه با مدیریت خطاهای احتمالی)
class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}
