import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoadingNext extends NotificationsState {
  final dynamic user;
  AppMessage? message;
  String? error;
  final List<NotificationItem> notifications;
  final bool? isNotificationGranted;
  final bool isSubscribed;
  final bool hasMore;
  NotificationsLoadingNext({
    required this.user,
    required this.notifications,
    required this.isNotificationGranted,
    required this.isSubscribed,
    required this.hasMore,
    this.message,
    this.error,
  });
}

class NotificationsAuthenticated extends NotificationsState {
  final dynamic user;
  AppMessage? message;
  String? error;
  final List<NotificationItem> notifications;
  final bool? isNotificationGranted;
  final bool isSubscribed;
  final bool hasMore;
  bool? isLoading;
  NotificationsAuthenticated({
    required this.user,
    required this.notifications,
    required this.isNotificationGranted,
    required this.isSubscribed,
    required this.hasMore,
    this.message,
    this.error,
    this.isLoading,
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
