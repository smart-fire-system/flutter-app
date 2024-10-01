abstract class SignUpEvent {}

class AuthChanged extends SignUpEvent {
  final String? error;
  AuthChanged({this.error});
}

class SignUpRequested extends SignUpEvent {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String countryCode;
  SignUpRequested(
      {required this.email,
      required this.password,
      required this.name,
      required this.phone,
      required this.countryCode});
}

class GoogleSignUpRequested extends SignUpEvent {}
