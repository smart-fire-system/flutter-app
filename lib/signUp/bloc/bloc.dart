import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'event.dart';
import 'state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>((event, emit) async {
      emit(SignUpLoading());
      try {
        await authRepository.signUpWithEmailAndPassword(event.email,
            event.password, event.name, event.phone, event.countryCode);
        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpFailure(error: error.toString()));
      }
    });

    on<AuthStatusRequested>((event, emit) async {
      try {
        bool isAuthenticated = await authRepository.isUserAuthenticated();
        if (isAuthenticated)
        {
          emit(SignUpSuccess());
        }
        else
        {
          emit(SignUpNotAuthenticated());
        }
        
      } catch (error) {
        emit(SignUpFailure(error: error.toString()));
      }
    });

    on<GoogleSignUpRequested>((event, emit) async {
      emit(SignUpLoading());
      try {
        await authRepository.signUpWithGoogle();
        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpFailure(error: error.toString()));
      }
    });

    on<FacebookSignUpRequested>((event, emit) async {
      emit(SignUpLoading());
      try {
        await authRepository.signUpWithFacebook();
        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpFailure(error: error.toString()));
      }
    });
  }
}
