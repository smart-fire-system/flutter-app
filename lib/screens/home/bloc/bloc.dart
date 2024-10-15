import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc({required this.authRepository}) : super(HomeInitial()) {
    HomeState getHomeState({String? message, String? error}) {
      if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated) {
        return HomeNotAuthenticated(message: message, error: error);
      } else {
        return HomeAuthenticated(
            user: authRepository.userAuth.user!,
            isEmailVerified:
                authRepository.userAuth.authStatus == AuthStatus.authenticated,
            isPhoneAdded: authRepository.userAuth.user!.phoneNumber.isNotEmpty,
            hasUserRole: authRepository.userAuth.user!.role != UserRole.noRole,
            message: message,
            error: error);
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
        emit(getHomeState(message: "Email Sent"));
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
  }
}
