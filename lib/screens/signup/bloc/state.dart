abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpNotAuthenticated extends SignUpState {
  final String? error;
  SignUpNotAuthenticated({required this.error});
}
