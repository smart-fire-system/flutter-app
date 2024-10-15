import 'package:fire_alarm_system/models/user.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeAuthenticated extends HomeState {
  final User user;
  final bool isEmailVerified;
  final bool isPhoneAdded;
  final bool hasUserRole;
  final String? message;
  final String? error;
  HomeAuthenticated({
    required this.user,
    required this.isEmailVerified,
    required this.isPhoneAdded,
    required this.hasUserRole,
    this.message,
    this.error,
  });
}

class HomeNotAuthenticated extends HomeState {
  String? message;
  String? error;
  HomeNotAuthenticated({this.message, this.error});
}

class HomeNoInternet extends HomeState {}