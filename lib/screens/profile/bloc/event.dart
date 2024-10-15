abstract class ProfileEvent {}

class AuthChanged extends ProfileEvent {
  final String? error;
  AuthChanged({this.error});
}

class ResetPasswordRequested extends ProfileEvent {}

class LogoutRequested extends ProfileEvent {}

class RefreshRequested extends ProfileEvent {}

class ChangeInfoRequested extends ProfileEvent {
  final String name;
  final String countryCode;
  final String phoneNumber;
  ChangeInfoRequested(
      {required this.name,
      required this.countryCode,
      required this.phoneNumber});
}
