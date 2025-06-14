import 'package:fire_alarm_system/models/pin.dart';

abstract class SystemEvent {}

class AuthChanged extends SystemEvent {
  final String? error;
  AuthChanged({this.error});
}

class RefreshRequested extends SystemEvent {
  final int branchCode;

  RefreshRequested({required this.branchCode});
}

class CancelStreamRequested extends SystemEvent {
  CancelStreamRequested();
}

class LastSeenRequested extends SystemEvent {
  final int branchCode;
  LastSeenRequested({required this.branchCode});
}

class MasterDataChanged extends SystemEvent {
  final List<Master> masters;

  MasterDataChanged({required this.masters});
}

class SendCommandRequested extends SystemEvent {
  final int branchCode;
  final int masterId;
  final int clientId;
  final int pinIndex;
  final AppHwRequest request;
  final PinConfig? pinConfig;
  SendCommandRequested({
    required this.branchCode,
    required this.masterId,
    required this.clientId,
    required this.pinIndex,
    required this.request,
    this.pinConfig,
  });
}
