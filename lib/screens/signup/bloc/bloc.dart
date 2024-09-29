import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/models/user_auth.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<ResetStateRequested>((event, emit) async {
      emit(SignUpInitial());
    });
    
    on<AuthRequested>((event, emit) async {
      emit(SignUpLoading());
      UserAuth user = authRepository.getUserAuth();
      if (user.authStatus == AuthStatus.notAuthenticated) {
        emit(SignUpNotAuthenticated(error: null));
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
        await authRepository.signUpWithGoogle();
        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpNotAuthenticated(error: error.toString()));
      }
    });

    on<FacebookSignUpRequested>((event, emit) async {
      emit(SignUpLoading());
      try {
        await authRepository.signUpWithFacebook();
        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpNotAuthenticated(error: error.toString()));
      }
    });
  }
}
