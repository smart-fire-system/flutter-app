import 'dart:io';

import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
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

class CompanyModifyRequested extends BranchesEvent {
  Company company;
  File? logoFile;
  CompanyModifyRequested({required this.company, this.logoFile});
}

class CompanyAddRequested extends BranchesEvent {
  Company company;
  File logoFile;

  CompanyAddRequested({required this.company, required this.logoFile});
}

class CompanyDeleteRequested extends BranchesEvent {
  String id;
  List<Branch> branches;
  CompanyDeleteRequested({required this.id, required this.branches});
}
