import 'package:skill_scanner/services/auth/auth_provider.dart';
import 'package:skill_scanner/services/auth/auth_user.dart'; // حتما این خط را اضافه کنید
import 'package:test/test.dart';

class MockAuthProvider implements AuthProvider {
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // طبق دستور 21
    throw UnimplementedError();
  }

  @override
  AuthUser? get currentUser => throw UnimplementedError();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<void> initialize() => throw UnimplementedError();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<void> logOut() => throw UnimplementedError();

  @override
  Future<void> sendEmailVerification() => throw UnimplementedError();
}
