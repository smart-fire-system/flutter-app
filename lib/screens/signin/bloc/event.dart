abstract class SignInEvent {}

class AuthChanged extends SignInEvent {
  final String? error;
  AuthChanged({this.error});
}

class ResetPasswordRequested extends SignInEvent {}

class LoginRequested extends SignInEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class SignUpRequested extends SignInEvent {
  final String email;
  final String password;
  final String name;
  SignUpRequested(
      {required this.email, required this.password, required this.name});
}

class GoogleSignInRequested extends SignInEvent {}
