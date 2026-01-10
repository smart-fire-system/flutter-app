
abstract class NotificationsEvent {}

class Refresh extends NotificationsEvent {}

class RequestNotificationPermission extends NotificationsEvent {}

class SubscribeToUserTopics extends NotificationsEvent {}

class UnsubscribeFromUserTopics extends NotificationsEvent {}