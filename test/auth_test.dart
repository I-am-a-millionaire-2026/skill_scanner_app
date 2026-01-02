import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  test('Should be able to create auth user', () {
    final user = AuthUser(
      // پارامتر id را حذف کنید چون خطا می‌دهد
      email: 'test@gmail.com', // طبق مرحله ۷ اضافه شد
      isEmailVerified: true,
    );
    expect(user.email, 'test@gmail.com');
  });
}
