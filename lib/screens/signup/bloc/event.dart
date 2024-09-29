abstract class SignUpEvent {}

class ResetStateRequested extends SignUpEvent {}

class AuthRequested extends SignUpEvent {}

class GoogleSignUpRequested extends SignUpEvent {}

class FacebookSignUpRequested extends SignUpEvent {}

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
