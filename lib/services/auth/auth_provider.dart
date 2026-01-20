import 'package:skill_scanner/services/auth/auth_user.dart';

abstract class AuthProvider {
  // Required for professional startup
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> logIn({required String email, required String password});

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  // دستور شماره 6: اضافه کردن امضای تابع برای بازیابی رمز عبور
  Future<void> sendPasswordReset({required String toEmail});
}
