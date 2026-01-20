import 'package:flutter/foundation.dart' show immutable;
import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState extends Equatable {
  // دستور 5 و 6: اضافه کردن فیلدها به کلاس پایه
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });

  @override
  List<Object?> get props => [isLoading, loadingText];
}

// دستور 7: اضافه کردن قابلیت لودینگ به وضعیت اولیه
class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

// دستور 8: مدیریت لودینگ در وضعیت ثبت‌نام
class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required super.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

// دستور 9: مدیریت لودینگ در وضعیت ورود
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});

  @override
  List<Object?> get props => [user, isLoading];
}

// دستور 10: مدیریت لودینگ در وضعیت تایید ایمیل
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

// دستور 11: مدیریت کامل لودینگ و متن آن در وضعیت خروج
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [exception, isLoading, loadingText];
}
