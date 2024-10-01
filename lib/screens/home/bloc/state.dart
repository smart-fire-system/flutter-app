import 'package:fire_alarm_system/models/user.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeAuthenticated extends HomeState {
  final User user;
  final String? error;
  HomeAuthenticated({required this.user, this.error});
}

class HomeNotVerified extends HomeState {
  final User user;
  final String? error;
  final bool? emailSent;
  HomeNotVerified({required this.user, this.error, this.emailSent});
}

class HomeNoRole extends HomeState {
  final User user;
  final String? error;
  HomeNoRole({required this.user, this.error});
}

class HomeError extends HomeState {
  final String error;
  HomeError({required this.error});
}

class HomeNotAuthenticated extends HomeState {}