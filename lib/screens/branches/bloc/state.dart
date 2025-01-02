import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';

enum BranchesMessage {
  branchModified,
  branchAdded,
  branchDeleted,
}

abstract class BranchesState {}

class BranchesInitial extends BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesAuthenticated extends BranchesState {
  final User user;
  final List<Branch> branches;
  final List<Company> companies;
  BranchesMessage? message;
  String? error;
  BranchesAuthenticated({
    required this.user,
    required this.branches,
    required this.companies,
    this.message,
    this.error,
  });
}

class BranchesNotAuthenticated extends BranchesState {
  String? error;
  BranchesNotAuthenticated({this.error});
}