import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsAuthenticated extends NotificationsState {
  final dynamic user;
  AppMessage? message;
  String? error;
  List<NotificationItem> notifications;
  bool? isNotificationGranted;
  bool isSubscribed;
  NotificationsAuthenticated({
    required this.user,
    required this.notifications,
    required this.isNotificationGranted,
    required this.isSubscribed,
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
