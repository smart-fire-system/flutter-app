import 'package:fire_alarm_system/models/pin.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class SystemState {}

class SystemInitial extends SystemState {}

class SystemLoading extends SystemState {}

class SystemAuthenticated extends SystemState {
  final List<Master> masters;
  final AppMessage? message;
  final String? error;
  SystemAuthenticated({
    this.masters = const [],
    this.message,
    this.error,
  });
}

class SystemNotAuthenticated extends SystemState {
  final AppMessage? message;
  final String? error;
  SystemNotAuthenticated({
    this.message,
    this.error,
  });
}
