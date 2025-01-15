import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

abstract class BranchesEvent {}

class AuthChanged extends BranchesEvent {
  final BranchesMessage? message;
  final String? error;
  AuthChanged({this.message, this.error});
}

class BranchModifyRequested extends BranchesEvent {
  Branch branch;
  BranchModifyRequested({required this.branch});
}

class BranchAddRequested extends BranchesEvent {
  Branch branch;
  BranchAddRequested({required this.branch});
}

class BranchDeleteRequested extends BranchesEvent {
  String id;
  BranchDeleteRequested({required this.id});
}