import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'event.dart';
import 'state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<AuthRequested>((event, emit) async {
      emit(SignUpLoading());
      User user = authRepository.getUserInfo();
      if (user.authStatus == AuthStatus.notAuthenticated) {
        emit(SignUpNotAuthenticated(error: null));
      } else {
        emit(SignUpSuccess(user: user));
      }
    });

    on<ResetState>((event, emit) async {
      emit(SignUpInitial());
    });

    on<SignUpSubmitted>((event, emit) async {
      emit(SignUpLoading());
      User user;
      try {
        user = await authRepository.signUpWithEmailAndPassword(event.email,
            event.password, event.name, event.phone, event.countryCode);
        emit(SignUpSuccess(user: user));
      } catch (error) {
        emit(SignUpNotAuthenticated(error: error.toString()));
      }
    });

    on<GoogleSignUpRequested>((event, emit) async {
      emit(SignUpLoading());
      User user;
      try {
        user = await authRepository.signUpWithGoogle();
        emit(SignUpSuccess(user: user));
      } catch (error) {
        emit(SignUpNotAuthenticated(error: error.toString()));
      }
    });

    on<FacebookSignUpRequested>((event, emit) async {
      emit(SignUpLoading());
      User user;
      try {
        user = await authRepository.signUpWithFacebook();
        emit(SignUpSuccess(user: user));
      } catch (error) {
        emit(SignUpNotAuthenticated(error: error.toString()));
      }
    });
  }
}
