import 'package:fire_alarm_system/models/user.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final User user;
  SignUpSuccess({required this.user});
}

class SignUpNotAuthenticated extends SignUpState {
  final String? error;
  SignUpNotAuthenticated({required this.error});
}
