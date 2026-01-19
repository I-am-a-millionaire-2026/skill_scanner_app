import 'package:bloc/bloc.dart';
import 'package:skill_scanner/services/auth/auth_provider.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateUninitialized(isLoading: true)) {
    // [Send Email Verification]
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // [Register]
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      emit(const AuthStateRegistering(exception: null, isLoading: true));
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } catch (e) {
        emit(AuthStateRegistering(exception: e as Exception, isLoading: false));
      }
    });

    // دستور ۳۰: Handle AuthEventInitialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        // دستور ۳۰: اگر کاربر لاگین نیست، وضعیت LoggedOut صادر شود
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // دستور ۳۱ تا ۳۴: مدیریت دقیق Log In
    on<AuthEventLogIn>((event, emit) async {
      // دستور ۳۱: نمایش لودینگ با ارسال وضعیت LoggedOut و isLoading: true
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Logging in...',
        ),
      );
      try {
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );

        if (!user.isEmailVerified) {
          // دستور ۳۲: ابتدا لودینگ را با ارسال LoggedOut(isLoading: false) متوقف می‌کنیم
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          // سپس به وضعیت نیاز به تایید می‌رویم
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          // دستور ۳۳: اگر ایمیل تایید شده، ابتدا لودینگ را قطع می‌کنیم
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          // سپس وضعیت نهایی LoggedIn را صادر می‌کنیم تا نوت‌ها لود شوند
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } catch (e) {
        // دستور ۳۴: مدیریت صحیح خطاها در وضعیت LoggedOut
        emit(AuthStateLoggedOut(exception: e as Exception, isLoading: false));
      }
    });

    // [Log Out] با رعایت ساختار دستور ۳۴
    on<AuthEventLogOut>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Logging out...',
        ),
      );
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } catch (e) {
        emit(AuthStateLoggedOut(exception: e as Exception, isLoading: false));
      }
    });

    // [Should Register]
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });
  }
}
