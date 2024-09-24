import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc({required this.authRepository}) : super(HomeInitial()) {
    on<ResetState>((event, emit) {
      emit(HomeInitial());
    });

    on<AuthRequested>((event, emit) async {
      emit(HomeLoading());
      User user = authRepository.getUserInfo();
      if (user.authStatus == AuthStatus.notAuthenticated) {
        emit(HomeNotAuthenticated());
      } else if (user.authStatus ==
          AuthStatus.authenticatedWithEmailNotVerified) {
        emit(HomeNotVerified(user: user));
      } else if (user.role == null) {
        emit(HomeNoRole(user: user));
      } else {
        emit(HomeAuthenticated(user: user));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.resendActivationEmail();
        User user = authRepository.getUserInfo();
        if (user.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (user.authStatus ==
            AuthStatus.authenticatedWithEmailNotVerified) {
          emit(HomeNotVerified(user: user));
        } else if (user.role == null) {
          emit(HomeNoRole(user: user));
        } else {
          emit(HomeAuthenticated(user: user));
        }
      } catch (error) {
        emit(HomeError(error: error.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signOut();
        User user = authRepository.getUserInfo();
        if (user.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (user.authStatus ==
            AuthStatus.authenticatedWithEmailNotVerified) {
          emit(HomeNotVerified(user: user));
        } else if (user.role == null) {
          emit(HomeNoRole(user: user));
        } else {
          emit(HomeAuthenticated(user: user));
        }
      } catch (error) {
        emit(HomeError(error: error.toString()));
      }
    });
  }
}
