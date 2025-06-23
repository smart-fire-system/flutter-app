import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppRepository appRepository;

  HomeBloc({required this.appRepository}) : super(HomeInitial()) {
    Future<HomeState> getHomeState({AppMessage? message, String? error}) async {
      if (appRepository.authStatus == AuthStatus.notAuthenticated) {
        return HomeNotAuthenticated(message: message, error: error);
      } else {
        UserInfo userInfo = appRepository.userInfo;
        if (appRepository.authStatus == AuthStatus.authenticatedNotVerified ||
            userInfo.phoneNumber.isEmpty ||
            appRepository.userRole is NoRoleUser) {
          return HomeNotAuthorized(
            user: appRepository.userRole,
            isEmailVerified:
                appRepository.authStatus == AuthStatus.authenticated,
            message: message,
            error: error,
          );
        } else {
          return HomeAuthenticated(
            user: appRepository.userRole,
            message: message,
            error: error,
          );
        }
      }
    }

    appRepository.authStateStream.listen((data) {
      add(AuthChanged(error: data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) async {
      if (event.error == null) {
        emit(await getHomeState());
      } else {
        emit(await getHomeState(error: event.error!));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signInWithGoogle();
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.resendActivationEmail();
        emit(await getHomeState(message: AppMessage.emailConfirmationSent));
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<RefreshRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.refreshUserAuth();
        emit(await getHomeState());
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signOut();
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.sendPasswordResetEmail();
        emit(await getHomeState(message: AppMessage.resetPasswordEmailSent));
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signIn(event.email, event.password);
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await appRepository.authRepository.signUpWithEmailAndPassword(
            event.email, event.password, event.name);
      } catch (error) {
        emit(await getHomeState(error: error.toString()));
      }
    });
  }
}
