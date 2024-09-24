import 'package:fire_alarm_system/models/user.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class ResetEmailSent extends LoginState {
  final String? error;
  ResetEmailSent({this.error});
}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess({required this.user});
}

class LoginNotAuthenticated extends LoginState {
  final String? error;
  LoginNotAuthenticated({this.error});
}
