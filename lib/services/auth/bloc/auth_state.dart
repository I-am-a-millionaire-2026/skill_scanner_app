import 'package:flutter/foundation.dart' show immutable;
import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState extends Equatable {
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });

  @override
  List<Object?> get props => [isLoading, loadingText];
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

// دستور شماره 8: اضافه شدن وضعیت ثبت‌نام
class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required super.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});

  @override
  List<Object?> get props => [user, isLoading];
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

// دستور شماره 9، 10 و 12: استفاده از Equatable و مدیریت isLoading و Exception
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
