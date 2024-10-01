import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated ||
          event.error == null) {
        emit(SignUpNotAuthenticated(error: event.error));
      } else {
        emit(SignUpSuccess());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(SignUpLoading());
      try {
        await authRepository.signUpWithEmailAndPassword(event.email,
            event.password, event.name, event.phone, event.countryCode);
        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpNotAuthenticated(error: error.toString()));
      }
    });

    on<GoogleSignUpRequested>((event, emit) async {
      emit(SignUpLoading());
      try {
        await authRepository.signInWithGoogle();
      } catch (error) {
        emit(SignUpNotAuthenticated(error: error.toString()));
      }
    });
  }
}
