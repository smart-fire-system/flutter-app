abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {}

class ResetEmailSent extends SignInState {
  final String? error;
  ResetEmailSent({this.error});
}

class SignInNotAuthenticated extends SignInState {
  final String? error;
  SignInNotAuthenticated({this.error});
}
