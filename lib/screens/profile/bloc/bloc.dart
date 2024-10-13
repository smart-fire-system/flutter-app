import 'package:fire_alarm_system/repositories/user_repository.dart';
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
        if (authRepository.userAuth.authStatus == AuthStatus.notAuthenticated) {
          emit(ProfileNotAuthenticated());
        } else if (authRepository.userAuth.authStatus ==
            AuthStatus.authenticatedNotVerified) {
          emit(ProfileNotVerified(user: authRepository.userAuth.user!));
        } else if (authRepository.userAuth.user!.role == UserRole.noRole) {
          emit(ProfileNoRole(user: authRepository.userAuth.user!));
        } else {
          emit(ProfileAuthenticated(user: authRepository.userAuth.user!));
        }
      } else {
        emit(ProfileError(error: event.error!));
      }
    });

    on<ChangeInfoRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        final userRepository = UserRepository(authRepository: authRepository);
        await userRepository.updateInformation(
            name: event.name,
            countryCode: event.countryCode,
            phoneNumber: event.phoneNumber);
        await authRepository.refreshUserAuth();
        emit(InfoUpdated());
      } catch (error) {
        emit(InfoUpdated(error: error.toString()));
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
        emit(ResetEmailSent());
      } catch (error) {
        emit(ResetEmailSent(error: error.toString()));
      }
    });

    on<ResendEmailRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await authRepository.resendActivationEmail();
        emit(VerificationEmailSent());
      } catch (error) {
        emit(VerificationEmailSent(error: error.toString()));
      }
    });
  }
}
