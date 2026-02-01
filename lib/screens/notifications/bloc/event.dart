abstract class NotificationsEvent {}

class Refresh extends NotificationsEvent {}

class LoadNextNotifications extends NotificationsEvent {}

class RequestNotificationPermission extends NotificationsEvent {}

class EnableNotifications extends NotificationsEvent {}

class DisableNotifications extends NotificationsEvent {}
