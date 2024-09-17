abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

class GoogleLoginRequested extends LoginEvent {}

class AuthStatusRequested extends LoginEvent {}

class FacebookLoginRequested extends LoginEvent {}
