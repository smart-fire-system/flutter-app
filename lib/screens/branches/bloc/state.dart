import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';

enum BranchesMessage {
  branchModified,
  branchAdded,
  branchDeleted,
  companyModified,
  companyAdded,
  companyDeleted,
}

abstract class BranchesState {}

class BranchesInitial extends BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesAuthenticated extends BranchesState {
  dynamic user;
  final List<Branch> branches;
  final List<Company> companies;
  String? createdId;
  BranchesMessage? message;
  String? error;
  BranchesAuthenticated({
    required this.user,
    this.branches = const [],
    this.companies = const [],
    this.createdId,
    this.message,
    this.error,
  });
}

class BranchesNotAuthenticated extends BranchesState {
  BranchesNotAuthenticated();
}
