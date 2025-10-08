import 'package:fire_alarm_system/repositories/auth_repository.dart';

abstract class HomeEvent {}

class AuthChanged extends HomeEvent {
  final AuthChangeResult? error;
  AuthChanged({this.error});
}

class ResendEmailRequested extends HomeEvent {}

class RefreshRequested extends HomeEvent {}

class LogoutRequested extends HomeEvent {}

class GoogleLoginRequested extends HomeEvent {}

class ResetPasswordRequested extends HomeEvent {}

class LoginRequested extends HomeEvent {
  final String email;
  final String password;
  LoginRequested({
    required this.email,
    required this.password,
  });
}

class SignUpRequested extends HomeEvent {
  final String email;
  final String password;
  final String name;
  SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });
}

class UpdatePhoneNumberRequested extends HomeEvent {
  final String name;
  final String phoneNumber;
  final String countryCode;
  UpdatePhoneNumberRequested({
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
  });
}