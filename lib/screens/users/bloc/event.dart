import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class UsersEvent {}

class AuthChanged extends UsersEvent {
  final AppMessage? message;
  final String? error;
  AuthChanged({this.message, this.error});
}

class AddRequested extends UsersEvent {
  final String userId;
  final AppPermissions permissions;
  final String companyId;
  final String branchId;
  AddRequested({
    required this.userId,
    required this.permissions,
    this.companyId = '',
    this.branchId = '',
  });
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

class DeleteRequested extends UsersEvent {
  final String userId;
  final UserRole userRole;
  DeleteRequested({
    required this.userId,
    required this.userRole,
  });
}
