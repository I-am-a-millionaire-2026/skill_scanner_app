import 'package:firebase_auth/firebase_auth.dart';
import 'auth_user.dart';

class AuthService {
  static final AuthService _shared = AuthService._sharedInstance();
  AuthService._sharedInstance();
  factory AuthService.firebase() => _shared;

  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return AuthUser.fromFirebase(user);
  }

  Future<void> logIn({required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
  }

  // دستور شماره 8: اضافه کردن قابلیت ارسال ایمیل بازیابی به سرویس
  Future<void> sendPasswordReset({required String toEmail}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
  }
}
