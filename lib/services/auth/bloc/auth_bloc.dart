import 'package:bloc/bloc.dart';
import 'package:skill_scanner/services/auth/auth_provider.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/services/auth/bloc/auth_state.dart';

// 1️⃣ ساخت کلاس AuthBloc که از کلاس Bloc ارث‌بری می‌کند
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // این بلاک با وضعیت Loading شروع به کار می‌کند
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // 2️⃣ منطق راه‌اندازی (Initialize)
    // بررسی می‌کند که آیا کاربر از قبل وارد شده است یا خیر
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // 3️⃣ منطق ورود (Log In)
    // تلاش برای ورود و مدیریت خطاها بدون از دست دادن اطلاعات قبلی
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading()); // نمایش لودینگ هنگام تلاش برای ورود
      try {
        final email = event.email;
        final password = event.password;
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      } catch (e) {
        // اگر خطایی رخ دهد، وضعیت خارج شده را به همراه خطا می‌فرستد
        emit(AuthStateLoggedOut(e as Exception));
      }
    });

    // 4️⃣ منطق خروج (Log Out)
    // پاکسازی وضعیت فعلی و برگرداندن کاربر به صفحه ورود
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } catch (e) {
        emit(AuthStateLoggedOut(e as Exception));
      }
    });
  }
}
