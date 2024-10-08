import 'package:fire_alarm_system/models/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAuthenticated extends ProfileState {
  final User user;
  final String? error;
  ProfileAuthenticated({required this.user, this.error});
}

class ProfileNotVerified extends ProfileState {
  final User user;
  final String? error;
  final bool? emailSent;
  ProfileNotVerified({required this.user, this.error, this.emailSent});
}

class ProfileNoRole extends ProfileState {
  final User user;
  final String? error;
  ProfileNoRole({required this.user, this.error});
}

class ProfileError extends ProfileState {
  final String error;
  ProfileError({required this.error});
}

class ResetEmailSent extends ProfileState {
  final String? error;
  ResetEmailSent({this.error});
}

class VerificationEmailSent extends ProfileState {
  final String? error;
  VerificationEmailSent({this.error});
}

class InfoUpdated extends ProfileState {
  final String? error;
  InfoUpdated({this.error});
}

class ProfileNotAuthenticated extends ProfileState {}
