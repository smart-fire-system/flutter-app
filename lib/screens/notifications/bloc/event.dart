import 'package:fire_alarm_system/screens/notifications/bloc/state.dart';

abstract class NotificationsEvent {}

class Refresh extends NotificationsEvent {
  final NotificationsAuthenticated? state;
  Refresh({this.state});
}

class LoadNextNotifications extends NotificationsEvent {}

class RequestNotificationPermission extends NotificationsEvent {}

class SubscribeToUserTopics extends NotificationsEvent {}

class UnsubscribeFromUserTopics extends NotificationsEvent {}
