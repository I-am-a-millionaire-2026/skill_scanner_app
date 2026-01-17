import 'package:skill_scanner/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  test('Should be able to create auth user', () {
    final user = AuthUser(
      id: '123ABC', // ✅ اضافه شد
      email: 'test@gmail.com',
      isEmailVerified: true,
    );

    expect(user.id, '123ABC'); // ✅ بررسی id
    expect(user.email, 'test@gmail.com');
    expect(user.isEmailVerified, true);
  });
}
