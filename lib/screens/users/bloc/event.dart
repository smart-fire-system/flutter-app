import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/utils/enums.dart';

abstract class UsersEvent {}

class AuthChanged extends UsersEvent {
  final UsersMessage? message;
  final String? error;
  AuthChanged({this.message, this.error});
}

class ModifyRequested extends UsersEvent {
  final String id;
  final UserRole oldRole;
  final UserRole newRole;
  ModifyRequested({required this.id, required this.oldRole, required this.newRole});
}