import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class UsersEvent {}

class Refresh extends UsersEvent {
  final AppMessage? message;
  final String? error;
  Refresh({this.message, this.error});
}

class ModifyRequested extends UsersEvent {
  final String userId;
  final AppPermissions permissions;
  final String companyId;
  final String branchId;
  ModifyRequested({
    required this.userId,
    required this.permissions,
    this.companyId = '',
    this.branchId = '',
  });
}
