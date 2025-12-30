import 'package:skill_scanner/services/auth/auth_user.dart'; //

abstract class AuthProvider {
  //

  // دریافت کاربر فعلی (اگر کسی وارد نشده باشد null برمی‌گرداند)
  AuthUser? get currentUser;

  // عملکرد ورود به سیستم
  Future<AuthUser> logIn({required String email, required String password});

  // عملکرد ایجاد حساب کاربری جدید
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  // عملکرد خروج از سیستم
  Future<void> logOut();

  // عملکرد ارسال ایمیل تاییدیه
  Future<void> sendEmailVerification();
}
