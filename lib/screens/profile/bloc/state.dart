import 'package:fire_alarm_system/models/user.dart';

enum ProfileMessage {
  infoUpdated,
  resetPasswordEmailSent
}

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAuthenticated extends ProfileState {
  final User user;
  final bool isAuthorized;
  final ProfileMessage? message;
  final String? error;
  ProfileAuthenticated({required this.user, required this.isAuthorized, this.message, this.error});
}

class ProfileNotAuthenticated extends ProfileState {
  final ProfileMessage? message;
  final String? error;
  ProfileNotAuthenticated({this.message, this.error});
}
