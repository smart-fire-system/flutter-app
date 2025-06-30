import 'package:fire_alarm_system/utils/message.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  final bool loadingData;
  final bool updatingData;
  final bool resettingPassword;
  final bool loggingOut;
  ProfileLoading({
    this.loadingData = false,
    this.updatingData = false,
    this.resettingPassword = false,
    this.loggingOut = false,
  });
}

class ProfileAuthenticated extends ProfileState {
  final dynamic user;
  final AppMessage? message;
  final String? error;
  ProfileAuthenticated({
    required this.user,
    this.message,
    this.error,
  });
}

class ProfileNotAuthenticated extends ProfileState {
  final AppMessage? message;
  final String? error;
  ProfileNotAuthenticated({
    this.message,
    this.error,
  });
}
