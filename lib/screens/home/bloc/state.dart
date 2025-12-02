import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeAuthenticated extends HomeState {
  final dynamic user;
  AppMessage? message;
  String? error;
  List<NotificationItem> notifications;
  HomeAuthenticated({
    required this.user,
    this.message,
    this.error,
    required this.notifications,
  });
}

class HomeNotAuthorized extends HomeState {
  final dynamic user;
  final bool isEmailVerified;
  AppMessage? message;
  String? error;
  HomeNotAuthorized({
    required this.user,
    required this.isEmailVerified,
    this.message,
    this.error,
  });
}

class HomeNotAuthenticated extends HomeState {
  AppMessage? message;
  String? error;
  HomeNotAuthenticated({this.message, this.error});
}

class HomeError extends HomeState {
  final AuthChangeResult error;
  HomeError({required this.error});
}
