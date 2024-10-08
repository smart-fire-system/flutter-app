import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated) {
        emit(LoginNotAuthenticated(error: event.error));
      } else {
        print("LoginSuccess");
        emit(LoginSuccess());
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.sendPasswordResetEmail();
        emit(ResetEmailSent());
      } catch (error) {
        emit(ResetEmailSent(error: error.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signIn(event.email, event.password);
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signInWithGoogle();
      } catch (error) {
        emit(LoginNotAuthenticated(error: error.toString()));
      }
    });
  }
}
