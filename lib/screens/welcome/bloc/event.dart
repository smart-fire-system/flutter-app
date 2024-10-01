abstract class WelcomeEvent {}

class AuthChanged extends WelcomeEvent {
  final String? error;
  AuthChanged({this.error});
}