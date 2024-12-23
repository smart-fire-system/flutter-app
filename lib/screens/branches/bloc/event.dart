import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

abstract class BranchesEvent {}

class AuthChanged extends BranchesEvent {
  final BranchesMessage? message;
  final String? error;
  AuthChanged({this.message, this.error});
}

class ModifyRequested extends BranchesEvent {
  Branch branch;
  ModifyRequested({required this.branch});
}

class AddRequested extends BranchesEvent {
  Branch branch;
  AddRequested({required this.branch});
}

class DeleteRequested extends BranchesEvent {
  String id;
  DeleteRequested({required this.id});
}