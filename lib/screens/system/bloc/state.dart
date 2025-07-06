import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/pin.dart';
import 'package:fire_alarm_system/utils/message.dart';

abstract class SystemState {}

class SystemInitial extends SystemState {}

class SystemLoading extends SystemState {}

class SystemAuthenticated extends SystemState {
  final List<Branch> branches;
  final List<Company> companies;
  final List<Master>? masters;
  final bool branchesChanged;
  final AppMessage? message;
  final String? error;
  SystemAuthenticated({
    required this.branches,
    required this.companies,
    this.masters,
    this.branchesChanged = false,
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
