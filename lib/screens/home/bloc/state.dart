import 'package:fire_alarm_system/models/user.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeAuthenticated extends HomeState {
  final User user;
  HomeAuthenticated({required this.user});
}

class HomeNotVerified extends HomeState {
  final User user;
  HomeNotVerified({required this.user});
}

class HomeNoRole extends HomeState {
  final User user;
  HomeNoRole({required this.user});
}

class HomeError extends HomeState {
  final String error;
  HomeError({required this.error});
}

class HomeNotAuthenticated extends HomeState {}