import 'package:test/test.dart';
import 'package:skill_scanner/services/auth/auth_provider.dart';
import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:skill_scanner/services/auth/auth_exceptions.dart';

// همان کلاس MockAuthProvider قبلی بدون تغییر در منطق، فقط برای تست‌های جدید استفاده می‌شود
class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedAuthException(); // مرحله ۲۳
    if (email == 'foo@bar.com') {
      _user = AuthUser(email: email, isEmailVerified: false);
      return _user!;
    } else {
      throw UserNotFoundAuthException();
    }
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedAuthException();
    if (email.isEmpty) throw GenericAuthException(); // مرحله ۲۶: Edge case
    _user = AuthUser(email: email, isEmailVerified: false);
    return _user!;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedAuthException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(milliseconds: 100));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedAuthException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    _user = AuthUser(email: user.email, isEmailVerified: true);
  }
}

// اضافه کردن استثنای جدید برای مرحله ۲۳ اگر قبلاً نساخته‌اید
class NotInitializedAuthException implements Exception {}

void main() {
  group('Mock Auth Complex Tests', () {
    final provider = MockAuthProvider();

    // مرحله ۲۲: تست عدم مقداردهی در شروع کار
    test('Provider shouldn\'t be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    // مرحله ۲۳: تست خروج قبل از Initialize (باید ارور بدهد)
    test('Test logging out before initialization', () {
      expect(provider.logOut(), throwsA(isA<NotInitializedAuthException>()));
    });

    // مرحله ۲۴: تست نال بودن کاربر در لحظه شروع
    test('The user should be null upon initialization', () async {
      await provider.initialize();
      expect(provider.currentUser, isNull);
    });

    // مرحله ۲۵: تست زمان مورد نیاز (Timeout)
    test('Testing time required to initialize', () async {
      await provider.initialize().timeout(const Duration(seconds: 2));
      expect(provider.isInitialized, true);
    });

    // مرحله ۲۶: تست ساخت کاربر و Edge Caseها
    test('Test creating a user', () async {
      final user = await provider.createUser(
        email: 'sara@test.com',
        password: '123',
      );
      expect(provider.currentUser, user);
      expect(user.email, 'sara@test.com');
      // Edge case: ایمیل خالی
      expect(
        provider.createUser(email: '', password: '123'),
        throwsA(isA<GenericAuthException>()),
      );
    });

    // مرحله ۲۷: تست ارسال تاییدیه ایمیل
    test(
      'A logged in user should be able to send email verification',
      () async {
        await provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user?.isEmailVerified, true);
      },
    );

    // مرحله ۲۸: تست سناریوی عادی ورود و خروج متوالی
    test('Test logging out and in again', () async {
      await provider.logOut();
      expect(provider.currentUser, isNull);
      await provider.logIn(email: 'foo@bar.com', password: 'baz');
      expect(provider.currentUser?.email, 'foo@bar.com');
    });
  });
}
