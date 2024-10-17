import 'package:fire_alarm_system/screens/users/bloc/admins/state.dart';
import 'package:fire_alarm_system/utils/enums.dart';

abstract class AdminsEvent {}

class AuthChanged extends AdminsEvent {
  final AdminMessage? message;
  final String? error;
  AuthChanged({this.message, this.error});
}

class ModifyRequested extends AdminsEvent {
  final String id;
  final UserRole oldRole;
  final UserRole newRole;
  ModifyRequested({required this.id, required this.oldRole, required this.newRole});
}