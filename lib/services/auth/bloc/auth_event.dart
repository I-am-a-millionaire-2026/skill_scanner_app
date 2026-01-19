import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

// 1️⃣ AuthEventInitialize: برای بررسی وضعیت اولیه کاربر هنگام باز شدن اپلیکیشن
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

// 2️⃣ AuthEventLogIn: رویدادی که هنگام تلاش کاربر برای ورود ارسال می‌شود
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

// 3️⃣ AuthEventLogOut: رویدادی که هنگام خروج کاربر از حساب کاربری ارسال می‌شود
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
