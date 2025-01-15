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
  final List<Branch> branches;
  final List<Company> companies;
  final bool canViewBranches;
  final bool canEditBranches;
  final bool canAddBranches;
  final bool canDeleteBranches;
  final bool canViewCompanies;
  final bool canEditCompanies;
  final bool canAddCompanies;
  final bool canDeleteCompanies;
  String? createdId;
  BranchesMessage? message;
  String? error;
  BranchesAuthenticated({
    required this.branches,
    required this.companies,
    this.canViewBranches = false,
    this.canEditBranches = false,
    this.canAddBranches = false,
    this.canDeleteBranches = false,
    this.canViewCompanies = false,
    this.canEditCompanies = false,
    this.canAddCompanies = false,
    this.canDeleteCompanies = false,
    this.createdId,
    this.message,
    this.error,
  });
}

class BranchesNotAuthenticated extends BranchesState {
  String? error;
  BranchesNotAuthenticated({this.error});
}