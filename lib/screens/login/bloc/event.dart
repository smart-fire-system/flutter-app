abstract class LoginEvent {}

class AuthChanged extends LoginEvent {
  final String? error;
  AuthChanged({this.error});
}

class ResetPasswordRequested extends LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class GoogleLoginRequested extends LoginEvent {}
