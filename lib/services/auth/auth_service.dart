import 'package:firebase_auth/firebase_auth.dart';
import 'auth_user.dart';

class AuthService {
  static final AuthService _shared = AuthService._sharedInstance();
  AuthService._sharedInstance();
  factory AuthService.firebase() => _shared;

  FirebaseAuth? _firebaseAuth;

  // ✅ Just get the instance
  Future<void> initializeOnce() async {
    _firebaseAuth = FirebaseAuth.instance;
  }

  AuthUser? get currentUser {
    final user = _firebaseAuth?.currentUser;
    if (user != null) {
      return AuthUser(email: user.email!, isEmailVerified: user.emailVerified);
    }
    return null;
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
    if (user != null) {
      await user.sendEmailVerification();
    }
  }
}
