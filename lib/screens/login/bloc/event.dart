abstract class LoginEvent {}

class ResetStateRequested extends LoginEvent {}

class AuthRequested extends LoginEvent {}

class GoogleLoginRequested extends LoginEvent {}

class FacebookLoginRequested extends LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class ResetPasswordRequested extends LoginEvent {
  final String email;
  ResetPasswordRequested({required this.email});
}
