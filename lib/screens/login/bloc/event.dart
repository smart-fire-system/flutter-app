abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

class ResetPasswordRequested extends LoginEvent {
  final String email;
  ResetPasswordRequested({required this.email});
}

class ResetState extends LoginEvent {}

class GoogleLoginRequested extends LoginEvent {}

class AuthRequested extends LoginEvent {}

class FacebookLoginRequested extends LoginEvent {}
