import 'package:skill_scanner/services/auth/auth_provider.dart';
import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:skill_scanner/services/auth/firebase_auth_provider.dart';

// ۳۰ و ۳۳: ایجاد کلاس AuthService که از قرارداد AuthProvider پیروی می‌کند
class AuthService implements AuthProvider {
  // ۳۴: این کلاس شامل یک ارائه‌دهنده (Provider) داخلی است
  final AuthProvider provider;

  // ۳۵: سازنده کلاس که پروایدر را دریافت می‌کند
  const AuthService(this.provider);

  // ۳۱: یک Factory constructor برای استفاده راحت از نسخه فایربیس در کل برنامه
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  // ۳۶: سپردن (Delegate) وظایف به پروایدر اصلی
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
