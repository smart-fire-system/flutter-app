import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppRepository appRepository;

  ProfileBloc({required this.appRepository}) : super(ProfileInitial()) {
    appRepository.authStateStream.listen((data) {
      add(AuthChanged(error: data));
    }, onError: (error) {
      add(AuthChanged(error: error.toString()));
    });

    on<AuthChanged>((event, emit) {
      if (event.error == null) {
        if (appRepository.authStatus == AuthStatus.notAuthenticated) {
          emit(ProfileNotAuthenticated());
        } else {
          emit(ProfileAuthenticated(
            user: appRepository.userRole,
          ));
        }
      } else {
        emit(ProfileNotAuthenticated(error: event.error!));
      }
    });

    on<ChangeInfoRequested>((event, emit) async {
      emit(ProfileLoading(updatingData: true));
      try {
        await appRepository.userRepository.updateInformation(
          name: event.name,
          countryCode: event.countryCode,
          phoneNumber: event.phoneNumber,
        );
        await appRepository.authRepository.refreshUserAuth();
        emit(ProfileAuthenticated(
          user: appRepository.userRole,
          message: AppMessage(id: AppMessageId.profileInfoUpdated),
        ));
      } catch (error) {
        emit(ProfileAuthenticated(
          user: appRepository.userRole,
          error: error.toString(),
        ));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(ProfileLoading(loggingOut: true));
      try {
        await appRepository.authRepository.signOut();
      } catch (error) {
        // Do nothing.
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(ProfileLoading(resettingPassword: true));
      try {
        await appRepository.authRepository.sendPasswordResetEmail();
        emit(ProfileAuthenticated(
          user: appRepository.userRole,
          message: AppMessage(id: AppMessageId.resetPasswordEmailSent),
        ));
      } catch (error) {
        emit(ProfileAuthenticated(
            user: appRepository.userRole, error: error.toString()));
      }
    });

    on<RefreshRequested>((event, emit) async {
      emit(ProfileLoading(loadingData: true));
      try {
        await appRepository.authRepository.refreshUserAuth();
        emit(ProfileAuthenticated(
          user: appRepository.userRole,
        ));
      } catch (error) {
        emit(ProfileAuthenticated(
            user: appRepository.userRole, error: error.toString()));
      }
    });
  }
}
