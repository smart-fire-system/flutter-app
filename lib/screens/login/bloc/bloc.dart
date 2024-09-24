import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<ResetState>((event, emit) {
      emit(LoginInitial());
    });

    on<AuthRequested>((event, emit) async {
      emit(LoginLoading());
      User user = authRepository.getUserInfo();
      if (user.authStatus == AuthStatus.notAuthenticated) {
        emit(LoginNotAuthenticated());
      } else {
        emit(LoginSuccess(user: user));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.sendPasswordResetEmail(event.email);
        emit(ResetEmailSent());
      } catch (error) {
        emit(ResetEmailSent(error: error.toString()));
      }
    });

    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      User user;
      try {
        user = await authRepository.signInWithEmailAndPassword(
            event.email, event.password);
        emit(LoginSuccess(user: user));
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      User user;
      emit(LoginLoading());
      try {
        user = await authRepository.signInWithGoogle();
        emit(LoginSuccess(user: user));
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });

    on<FacebookLoginRequested>((event, emit) async {
      User user;
      emit(LoginLoading());
      try {
        user = await authRepository.signInWithFacebook();
        emit(LoginSuccess(user: user));
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });
  }
}
