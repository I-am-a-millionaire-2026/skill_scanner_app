import 'package:bloc/bloc.dart';
import 'package:skill_scanner/services/auth/auth_provider.dart';
import 'package:skill_scanner/services/auth/bloc/auth_event.dart';
import 'package:skill_scanner/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateLoggedOut(exception: null, isLoading: true)) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // Log In - Removed AuthStateLoading emit per Step 2,
    // but using AuthStateLoggedOut(isLoading: true) to trigger overlays if needed.
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));
      try {
        final email = event.email;
        final password = event.password;
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification());
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user));
        }
      } catch (e) {
        emit(AuthStateLoggedOut(exception: e as Exception, isLoading: false));
      }
    });

    // Log Out
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } catch (e) {
        emit(AuthStateLoggedOut(exception: e as Exception, isLoading: false));
      }
    });
  }
}
