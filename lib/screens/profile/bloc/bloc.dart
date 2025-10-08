import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'event.dart';
import 'state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppRepository appRepository;
  AppMessage? message;

  ProfileBloc({required this.appRepository}) : super(ProfileInitial()) {
    on<Refresh>((event, emit) {
      if (event.error == null) {
        if (appRepository.authStatus == AuthStatus.notAuthenticated) {
          emit(ProfileNotAuthenticated(message: message));
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
        message = AppMessage(id: AppMessageId.profileInfoUpdated);
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
      } catch (_) {}
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
      } catch (error) {
        emit(ProfileAuthenticated(
            user: appRepository.userRole, error: error.toString()));
      }
    });

    add(Refresh());

    appRepository.authStateStream.listen((status) {
      add(Refresh());
    }, onError: (error) {
      add(Refresh(error: error.toString()));
    });

    appRepository.branchesAndCompaniesStream.listen((_) {
      add(Refresh());
    }, onError: (error) {
      add(Refresh(error: error.toString()));
    });

    appRepository.usersStream.listen((_) {
      add(Refresh());
    }, onError: (error) {
      add(Refresh(error: error.toString()));
    });
  }
}
