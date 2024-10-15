import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;

  SignInBloc({required this.authRepository}) : super(SignInInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated) {
        emit(SignInNotAuthenticated(error: event.error));
      } else {
        emit(SignInSuccess());
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(SignInLoading());
      try {
        await authRepository.sendPasswordResetEmail();
        emit(ResetEmailSent());
      } catch (error) {
        emit(ResetEmailSent(error: error.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(SignInLoading());
      try {
        await authRepository.signIn(event.email, event.password);
      } catch (error) {
        emit(SignInNotAuthenticated(error: error.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(SignInLoading());
      try {
        await authRepository.signUpWithEmailAndPassword(event.email,
            event.password, event.name);
      } catch (error) {
        emit(SignInNotAuthenticated(error: error.toString()));
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(SignInLoading());
      try {
        await authRepository.signInWithGoogle();
      } catch (error) {
        emit(SignInNotAuthenticated(error: error.toString()));
      }
    });
  }
}
