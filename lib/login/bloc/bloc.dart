import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signInWithEmailAndPassword(
            event.email, event.password);
        emit(LoginSuccess());
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });

    on<AuthStatusRequested>((event, emit) async {
      try {
        bool isAuthenticated = await authRepository.isUserAuthenticated();
        if (isAuthenticated)
        {
          emit(LoginSuccess());
        }
        else
        {
          emit(LoginNotAuthenticated());
        }
        
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signInWithGoogle();
        emit(LoginSuccess());
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });

    on<FacebookLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.signInWithFacebook();
        emit(LoginSuccess());
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}
