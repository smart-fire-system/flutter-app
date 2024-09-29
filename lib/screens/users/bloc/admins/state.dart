import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/user_auth.dart';
import 'package:fire_alarm_system/models/user.dart';

abstract class AdminsState {}

class AdminsInitial extends AdminsState {}

class AdminsLoading extends AdminsState {}

class AdminsAuthenticated extends AdminsState {
  final UserAuth user;
  final List<Admin> admins;
  AdminsAuthenticated({required this.user, required this.admins});
}

class AdminsNotAuthenticated extends AdminsState {}

class AdminsNotAuthorized extends AdminsState {}

class AdminsError extends AdminsState {
  final String error;
  AdminsError({required this.error});
}

class AdminModifed extends AdminsState {
  final String? error;
  AdminModifed({this.error});
}

class AdminDeleted extends AdminsState {
  final String? error;
  AdminDeleted({this.error});
}

class NoRoleListLoaded extends AdminsState {
  final List<User> users;
  NoRoleListLoaded({required this.users});
}