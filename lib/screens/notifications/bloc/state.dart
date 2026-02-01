import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsAuthenticated extends NotificationsState {
  final dynamic user;
  AppMessage? message;
  String? error;
  final List<NotificationItem> notifications;
  final bool? isNotificationsEnabled;
  final bool hasMore;
  bool isLoadingNext;
  bool isLoadingNotifications;
  bool isLoadingEnableOrDisable;
  NotificationsAuthenticated({
    required this.user,
    required this.notifications,
    required this.isNotificationsEnabled,
    required this.hasMore,
    this.isLoadingNotifications = false,
    this.isLoadingNext = false,
    this.isLoadingEnableOrDisable = false,
    this.message,
    this.error,
  });
}

class NotificationsNotAuthenticated extends NotificationsState {
  AppMessage? message;
  String? error;
  NotificationsNotAuthenticated({this.message, this.error});
}

class NotificationsError extends NotificationsState {
  final AuthChangeResult error;
  NotificationsError({required this.error});
}
