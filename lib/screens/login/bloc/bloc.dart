import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/models/user_auth.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<ResetStateRequested>((event, emit) {
      emit(LoginInitial());
    });

    on<AuthRequested>((event, emit) async {
      emit(LoginLoading());
      UserAuth userAuth = authRepository.getUserAuth();
      if (userAuth.authStatus == AuthStatus.notAuthenticated) {
        emit(LoginNotAuthenticated());
      } else {
        emit(LoginSuccess());
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

    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signInWithEmailAndPassword(
            event.email, event.password);
        emit(LoginSuccess());
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signInWithGoogle();
        emit(LoginSuccess());
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });

    on<FacebookLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signInWithFacebook();
        emit(LoginSuccess());
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });
  }
}
