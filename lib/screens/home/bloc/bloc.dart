import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/models/user_auth.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc({required this.authRepository}) : super(HomeInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) {
      if (event.error == null) {
        if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (authRepository.userAuth.authStatus ==
            AuthStatus.authenticatedNotVerified) {
          emit(HomeAuthenticatedNotVerified(
              user: authRepository.userAuth.user!));
        } else {
          emit(HomeAuthenticated(user: authRepository.userAuth.user!));
        }
      } else {
        emit(HomeNotAuthenticated(error: event.error!));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signInWithGoogle();
      } catch (error) {
        emit(HomeNotAuthenticated(error: error.toString()));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.resendActivationEmail();
        UserAuth userAuth = await authRepository.refreshUserAuth();
        emit(HomeAuthenticatedNotVerified(
            user: userAuth.user!, emailSent: true));
      } catch (error) {
        UserAuth userAuth = authRepository.userAuth;
        emit(HomeAuthenticatedNotVerified(
            user: userAuth.user!, error: error.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signOut();
      } catch (error) {
        emit(HomeNotAuthenticated(error: error.toString()));
      }
    });
  }
}
