import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/models/user_auth.dart';
import 'package:fire_alarm_system/utils/enums.dart';
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
      UserAuth userAuth = authRepository.getUserAuth();
      if (userAuth.authStatus == AuthStatus.notAuthenticated) {
        emit(HomeNotAuthenticated());
      } else if (userAuth.authStatus ==
          AuthStatus.authenticatedWithEmailNotVerified) {
        emit(HomeNotVerified(user: userAuth.user!));
      } else if (userAuth.user!.role == UserRole.noRole) {
        emit(HomeNoRole(user: userAuth.user!));
      } else {
        emit(HomeAuthenticated(user: userAuth.user!));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.resendActivationEmail();
        UserAuth userAuth = authRepository.getUserAuth();
        if (userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (userAuth.authStatus ==
            AuthStatus.authenticatedWithEmailNotVerified) {
          emit(HomeNotVerified(user: userAuth.user!));
        } else if (userAuth.user!.role == UserRole.noRole) {
          emit(HomeNoRole(user: userAuth.user!));
        } else {
          emit(HomeAuthenticated(user: userAuth.user!));
        }
      } catch (error) {
        emit(HomeError(error: error.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        await authRepository.signOut();
        UserAuth userAuth = authRepository.getUserAuth();
        if (userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(HomeNotAuthenticated());
        } else if (userAuth.authStatus ==
            AuthStatus.authenticatedWithEmailNotVerified) {
          emit(HomeNotVerified(user: userAuth.user!));
        } else if (userAuth.user!.role == UserRole.noRole) {
          emit(HomeNoRole(user: userAuth.user!));
        } else {
          emit(HomeAuthenticated(user: userAuth.user!));
        }
      } catch (error) {
        emit(HomeError(error: error.toString()));
      }
    });
  }
}
