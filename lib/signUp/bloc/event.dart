abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String countryCode;
  SignUpSubmitted(
      {required this.email,
      required this.password,
      required this.name,
      required this.phone,
      required this.countryCode});
}

class GoogleSignUpRequested extends SignUpEvent {}

class AuthStatusRequested extends SignUpEvent {}

class FacebookSignUpRequested extends SignUpEvent {}
