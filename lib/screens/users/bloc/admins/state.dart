import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/user.dart';

enum AdminMessage {
  userModified,
}

abstract class AdminsState {}

class AdminsInitial extends AdminsState {}

class AdminsLoading extends AdminsState {}

class AdminsAuthenticated extends AdminsState {
  final User user;
  final List<Admin> admins;
  final List<User> users;
  AdminMessage? message;
  String? error;
  AdminsAuthenticated({
    required this.user,
    required this.admins,
    required this.users,
    this.message,
    this.error,
  });
}

class AdminsNotAuthenticated extends AdminsState {
  String? error;
  AdminsNotAuthenticated({this.error});
}