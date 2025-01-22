import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc({required this.authRepository}) : super(HomeInitial()) {
    HomeState getHomeState({AppMessage? message, String? error}) {
      if (authRepository.authStatus == AuthStatus.notAuthenticated) {
        return HomeNotAuthenticated(message: message, error: error);
      } else {
        UserInfo userInfo = authRepository.userInfo;
        if (authRepository.authStatus == AuthStatus.authenticatedNotVerified ||
            userInfo.phoneNumber.isEmpty ||
            authRepository.userRole is NoRoleUser) {
          return HomeNotAuthorized(
            user: authRepository.userRole,
            isEmailVerified:
                authRepository.authStatus == AuthStatus.authenticated,
            message: message,
            error: error,
          );
        } else {
          return HomeAuthenticated(
            user: authRepository.userRole,
            message: message,
            error: error,
          );
        }
      }
    }

    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) {
      if (event.error == null) {
        emit(getHomeState());
      } else {
        emit(getHomeState(error: event.error!));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signInWithGoogle();
      } catch (error) {
        emit(getHomeState(error: error.toString()));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.resendActivationEmail();
        emit(getHomeState(message: AppMessage.emailConfirmationSent));
      } catch (error) {
        emit(getHomeState(error: error.toString()));
      }
    });

    on<RefreshRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.refreshUserAuth();
        emit(getHomeState());
      } catch (error) {
        emit(getHomeState(error: error.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signOut();
      } catch (error) {
        emit(getHomeState(error: error.toString()));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.sendPasswordResetEmail();
        emit(getHomeState(message: AppMessage.resetPasswordEmailSent));
      } catch (error) {
        emit(getHomeState(error: error.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signIn(event.email, event.password);
      } catch (error) {
        emit(getHomeState(error: error.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signUpWithEmailAndPassword(
            event.email, event.password, event.name);
      } catch (error) {
        emit(getHomeState(error: error.toString()));
      }
    });
  }
}
