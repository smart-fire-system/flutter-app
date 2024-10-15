import 'package:fire_alarm_system/models/user.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeAuthenticated extends HomeState {
  final User user;
  final String? error;
  HomeAuthenticated({required this.user, this.error});
}

class HomeAuthenticatedNotVerified extends HomeState {
  final User user;
  final String? error;
  final bool? emailSent;
  HomeAuthenticatedNotVerified(
      {required this.user, this.error, this.emailSent});
}

class HomeNotAuthenticated extends HomeState {
  String? error;
  HomeNotAuthenticated({this.error});
}

class HomeNoInternet extends HomeState {}