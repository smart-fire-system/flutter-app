import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';

enum UsersMessage {
  userModified,
}

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersAuthenticated extends UsersState {
  final User user;
  final List<Company> companies;
  final List<Branch> branches;
  final List<Admin> admins;
  final List<CompanyManager> companyManagers;
  final List<BranchManager> branchManagers;
  final List<Employee> employees;
  final List<Client> clients; 
  final List<NoRoleUser> noRoleUsers;
  UsersMessage? message;
  String? error;
  UsersAuthenticated({
    required this.user,
    this.companies = const [],
    this.branches = const [],
    this.admins = const [],
    this.companyManagers = const [],
    this.branchManagers = const [],
    this.employees = const [],
    this.clients = const [],
    this.noRoleUsers = const [],
    this.message,
    this.error,
  });
}

class UsersNotAuthenticated extends UsersState {
  String? error;
  UsersNotAuthenticated({this.error});
}