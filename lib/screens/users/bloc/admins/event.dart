import 'package:fire_alarm_system/utils/enums.dart';

abstract class AdminsEvent {}

class AuthRequested extends AdminsEvent {}

class NoRoleListRequested extends AdminsEvent {}

class DeleteRequested extends AdminsEvent {
  final String id;
  DeleteRequested({required this.id});
}

class ModifyRequested extends AdminsEvent {
  final String id;
  final UserRole newRole;
  ModifyRequested({required this.id, required this.newRole});
}

class ResetState extends AdminsEvent {}
