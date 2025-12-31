import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:skill_scanner/firebase_options.dart';
import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:skill_scanner/services/auth/auth_provider.dart';
import 'package:skill_scanner/services/auth/auth_exceptions.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    try {
      // بررسی دقیق برای جلوگیری از کرش و صفحه سفید
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      // اگر قبلاً مقداردهی شده باشد، از خطا عبور می‌کند تا برنامه متوقف نشود
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) return AuthUser.fromFirebase(user);
    return null;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) return user;
      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') throw UserNotFoundAuthException();
      if (e.code == 'wrong-password') throw WrongPasswordAuthException();
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) return user;
      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') throw WeakPasswordAuthException();
      if (e.code == 'email-already-in-use')
        throw EmailAlreadyInUseAuthException();
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) await user.sendEmailVerification();
  }
}
