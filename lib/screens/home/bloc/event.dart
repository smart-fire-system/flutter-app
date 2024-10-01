abstract class HomeEvent {}

class AuthChanged extends HomeEvent {
  final String? error;
  AuthChanged({this.error});
}

class ResendEmailRequested extends HomeEvent {}

class LogoutRequested extends HomeEvent {}
