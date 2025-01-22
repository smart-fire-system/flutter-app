abstract class HomeEvent {}

class AuthChanged extends HomeEvent {
  final String? error;
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
