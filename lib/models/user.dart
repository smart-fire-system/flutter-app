import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String countryCode;
  UserRole role;
  bool canViewBranches;
  bool canEditBranches;
  bool canAddBranches;
  bool canDeleteBranches;
  bool canViewCompanies;
  bool canEditCompanies;
  bool canAddCompanies;
  bool canDeleteCompanies;
  bool canviewAdmins;
  bool canEditAdmins;
  bool canAddAdmins;
  bool canDeleteAdmins;
  bool canviewCompanyManagers;
  bool canEditCompanyManagers;
  bool canAddCompanyManagers;
  bool canDeleteCompanyManagers;
  bool canviewBranchManagers;
  bool canEditBranchManagers;
  bool canAddBranchManagers;
  bool canDeleteBranchManagers;
  bool canviewEmployees;
  bool canEditEmployees;
  bool canAddEmployees;
  bool canDeleteEmployees;
  bool canviewClients;
  bool canEditClients;
  bool canAddClients;
  bool canDeleteClients;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.role,
    this.canViewBranches = true,
    this.canEditBranches = true,
    this.canAddBranches = true,
    this.canDeleteBranches = true,
    this.canViewCompanies = true,
    this.canEditCompanies = true,
    this.canAddCompanies = true,
    this.canDeleteCompanies = true,
    this.canviewAdmins = true,
    this.canEditAdmins = true,
    this.canAddAdmins = true,
    this.canDeleteAdmins = true,
    this.canviewCompanyManagers = true,
    this.canEditCompanyManagers = true,
    this.canAddCompanyManagers = true,
    this.canDeleteCompanyManagers = true,
    this.canviewBranchManagers = true,
    this.canEditBranchManagers = true,
    this.canAddBranchManagers = true,
    this.canDeleteBranchManagers = true,
    this.canviewEmployees = true,
    this.canEditEmployees = true,
    this.canAddEmployees = true,
    this.canDeleteEmployees = true,
    this.canviewClients = true,
    this.canEditClients = true,
    this.canAddClients = true,
    this.canDeleteClients = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'role': getRoleId(role),
      'canViewBranches': canViewBranches,
      'canEditBranches': canEditBranches,
      'canAddBranches': canAddBranches,
      'canDeleteBranches': canDeleteBranches,
      'canViewCompanies': canViewCompanies,
      'canEditCompanies': canEditCompanies,
      'canAddCompanies': canAddCompanies,
      'canDeleteCompanies': canDeleteCompanies,
      'canviewAdmins': canviewAdmins,
      'canEditAdmins': canEditAdmins,
      'canAddAdmins': canAddAdmins,
      'canDeleteAdmins': canDeleteAdmins,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'] as String,
      email: map['email'] as String,
      countryCode: map['countryCode'] as String,
      phoneNumber: map['phoneNumber'] as String,
      role: getRole(map['role'] as String),
      canViewBranches: map['canViewBranches'] as bool,
      canEditBranches: map['canEditBranches'] as bool,
      canAddBranches: map['canAddBranches'] as bool,
      canDeleteBranches: map['canDeleteBranches'] as bool,
      canViewCompanies: map['canViewCompanies'] as bool,
      canEditCompanies: map['canEditCompanies'] as bool,
      canAddCompanies: map['canAddCompanies'] as bool,
      canDeleteCompanies: map['canDeleteCompanies'] as bool,
      canviewAdmins: map['canviewAdmins'] as bool,
      canEditAdmins: map['canEditAdmins'] as bool,
      canAddAdmins: map['canAddAdmins'] as bool,
      canDeleteAdmins: map['canDeleteAdmins'] as bool,
    );
  }

  static String getRoleName(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return S.of(context).admin;
      case UserRole.companyManager:
        return S.of(context).companyManager;
      case UserRole.branchManager:
        return S.of(context).branchManager;
      case UserRole.employee:
        return S.of(context).employee;
      case UserRole.client:
        return S.of(context).client;
      default:
        return S.of(context).noRole;
    }
  }

  static String getRoleId(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.companyManager:
        return 'companyManager';
      case UserRole.branchManager:
        return 'branchManager';
      case UserRole.employee:
        return 'employee';
      case UserRole.client:
        return 'client';
      default:
        return '';
    }
  }

  static UserRole getRole(String roleId) {
    switch (roleId) {
      case 'admin':
        return UserRole.admin;
      case 'companyManager':
        return UserRole.companyManager;
      case 'branchManager':
        return UserRole.branchManager;
      case 'employee':
        return UserRole.employee;
      case 'client':
        return UserRole.client;
      default:
        return UserRole.noRole;
    }
  }
}

class NoRoleUser {
  User info;
  NoRoleUser({required this.info});
}

class Admin {
  User info;
  Admin({required this.info});
}

class CompanyManager {
  User info;
  Company company;
  List<Branch> branches;

  CompanyManager({
    required this.info,
    required this.company,
    required this.branches,
  });
}

class BranchManager {
  User info;
  Branch branch;

  BranchManager({
    required this.info,
    required this.branch,
  });
}

class Employee {
  User info;
  Branch branch;

  Employee({
    required this.info,
    required this.branch,
  });
}

class Client {
  User info;
  Branch branch;

  Client({
    required this.info,
    required this.branch,
  });
}
