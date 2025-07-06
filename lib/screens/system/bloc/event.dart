import 'package:fire_alarm_system/models/pin.dart';

abstract class SystemEvent {}

class AuthChanged extends SystemEvent {
  final String? error;
  AuthChanged({this.error});
}

class DataChanged extends SystemEvent {
  DataChanged();
}

class BranchesChanged extends SystemEvent {
  BranchesChanged();
}

class RefreshRequested extends SystemEvent {
  final int branchCode;
  RefreshRequested({required this.branchCode});
}

class CancelStreamRequested extends SystemEvent {
  CancelStreamRequested();
}

class MasterDeleteRequested extends SystemEvent {
  final int branchCode;
  final int masterId;
  MasterDeleteRequested({
    required this.branchCode,
    required this.masterId,
  });
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
