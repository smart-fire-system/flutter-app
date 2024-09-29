abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class ResetEmailSent extends LoginState {
  final String? error;
  ResetEmailSent({this.error});
}

class LoginNotAuthenticated extends LoginState {
  final String? error;
  LoginNotAuthenticated({this.error});
}
