import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;

  ProfileBloc({required this.authRepository}) : super(ProfileInitial()) {
    authRepository.authStateChanges.listen((data) {
      add(AuthChanged(error: data == "" ? null : data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) {
      if (event.error == null) {
        if (authRepository.authStatus == AuthStatus.notAuthenticated) {
          emit(ProfileNotAuthenticated());
        } else {
          emit(ProfileAuthenticated(
            user: authRepository.userRole,
          ));
        }
      } else {
        emit(ProfileNotAuthenticated(error: event.error!));
      }
    });

    on<ChangeInfoRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        final userRepository = UserRepository(authRepository: authRepository);
        await userRepository.updateInformation(
          name: event.name,
          countryCode: event.countryCode,
          phoneNumber: event.phoneNumber,
        );
        await authRepository.refreshUserAuth();
        emit(ProfileAuthenticated(
          user: authRepository.userRole,
          message: AppMessage.profileInfoUpdated,
        ));
      } catch (error) {
        emit(ProfileAuthenticated(
          user: authRepository.userRole,
          error: error.toString(),
        ));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await authRepository.signOut();
      } catch (error) {
        // Do nothing.
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await authRepository.sendPasswordResetEmail();
        emit(ProfileAuthenticated(
          user: authRepository.userRole,
          message: AppMessage.resetPasswordEmailSent,
        ));
      } catch (error) {
        emit(ProfileAuthenticated(
            user: authRepository.userRole, error: error.toString()));
      }
    });

    on<RefreshRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await authRepository.refreshUserAuth();
        emit(ProfileAuthenticated(
          user: authRepository.userRole,
        ));
      } catch (error) {
        emit(ProfileAuthenticated(
            user: authRepository.userRole, error: error.toString()));
      }
    });
  }
}
