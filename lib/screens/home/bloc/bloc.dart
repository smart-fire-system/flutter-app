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
          emit(HomeNotVerified(user: authRepository.userAuth.user!));
        } else if (authRepository.userAuth.user!.role == UserRole.noRole) {
          emit(HomeNoRole(user: authRepository.userAuth.user!));
        } else {
          emit(HomeAuthenticated(user: authRepository.userAuth.user!));
        }
      } else {
        emit(HomeError(error: event.error!));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.resendActivationEmail();
        UserAuth userAuth = await authRepository.refreshUserAuth();
        if (userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (userAuth.authStatus == AuthStatus.authenticatedNotVerified) {
          emit(HomeNotVerified(user: userAuth.user!, emailSent: true));
        } else if (userAuth.user!.role == UserRole.noRole) {
          emit(HomeNoRole(user: userAuth.user!));
        } else {
          emit(HomeAuthenticated(user: userAuth.user!));
        }
      } catch (error) {
        UserAuth userAuth = authRepository.userAuth;
        if (userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (userAuth.authStatus == AuthStatus.authenticatedNotVerified) {
          emit(HomeNotVerified(user: userAuth.user!, error: error.toString()));
        } else if (userAuth.user!.role == UserRole.noRole) {
          emit(HomeNoRole(user: userAuth.user!, error: error.toString()));
        } else {
          emit(
              HomeAuthenticated(user: userAuth.user!, error: error.toString()));
        }
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signOut();
        UserAuth userAuth = await authRepository.refreshUserAuth();
        if (userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (userAuth.authStatus == AuthStatus.authenticatedNotVerified) {
          emit(HomeNotVerified(user: userAuth.user!));
        } else if (userAuth.user!.role == UserRole.noRole) {
          emit(HomeNoRole(user: userAuth.user!));
        } else {
          emit(HomeAuthenticated(user: userAuth.user!));
        }
      } catch (error) {
        UserAuth userAuth = authRepository.userAuth;
        if (userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (userAuth.authStatus == AuthStatus.authenticatedNotVerified) {
          emit(HomeNotVerified(user: userAuth.user!, error: error.toString()));
        } else if (userAuth.user!.role == UserRole.noRole) {
          emit(HomeNoRole(user: userAuth.user!, error: error.toString()));
        } else {
          emit(
              HomeAuthenticated(user: userAuth.user!, error: error.toString()));
        }
      }
    });
  }
}
