import 'package:fire_alarm_system/models/app_version.dart';
import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeAuthenticated extends HomeState {
  final dynamic user;
  final bool isUpdateAvailable;
  bool openNotifications;
  AppMessage? message;
  String? error;
  List<NotificationItem> notifications;
  NotificationItem? notificationReceived;
  HomeAuthenticated({
    required this.user,
    required this.isUpdateAvailable,
    this.openNotifications = false,
    this.message,
    this.error,
    required this.notifications,
    this.notificationReceived,
  });
}

class HomeNotAuthorized extends HomeState {
  final dynamic user;
  final bool isEmailVerified;
  final bool isUpdateAvailable;
  AppMessage? message;
  String? error;
  HomeNotAuthorized({
    required this.user,
    required this.isEmailVerified,
    required this.isUpdateAvailable,
    this.message,
    this.error,
  });
}

class HomeNotAuthenticated extends HomeState {
  AppMessage? message;
  String? error;
  final bool isUpdateAvailable;
  HomeNotAuthenticated(
      {this.message, this.error, required this.isUpdateAvailable});
}

class HomeUpdateNeeded extends HomeState {
  AppMessage? message;
  String? error;
  AppVersionData appVersionData;
  HomeUpdateNeeded({
    this.message,
    this.error,
    required this.appVersionData,
  });
}

class HomeError extends HomeState {
  final AuthChangeResult error;
  HomeError({required this.error});
}
