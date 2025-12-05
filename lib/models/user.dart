import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter/material.dart';

class UserInfo {
  String id;
  int code;
  String name;
  String email;
  String phoneNumber;
  String countryCode;
  String signatureUrl;
  Timestamp? createdAt;

  UserInfo({
    this.id = "",
    this.code = 0,
    this.name = "",
    this.email = "",
    this.countryCode = "",
    this.phoneNumber = "",
    this.signatureUrl = "",
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'code': code,
      'signatureUrl': signatureUrl,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map, String id) {
    return UserInfo(
      id: id,
      name: map['name'] as String,
      email: map['email'] as String,
      countryCode: map['countryCode'] as String,
      phoneNumber: map['phoneNumber'] as String,
      createdAt: map['createdAt'] as Timestamp,
      code: map['code'] as int,
      signatureUrl: map['signatureUrl']?.toString() ?? "",
    );
  }

  static String getRoleName(BuildContext context, UserRole? role) {
    switch (role) {
      case UserRole.masterAdmin:
        return S.of(context).masterAdmin;
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
      case null:
        return S.of(context).noRole;
    }
  }

  static String getRoleId(UserRole role) {
    switch (role) {
      case UserRole.masterAdmin:
        return 'masterAdmin';
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
    }
  }

  static UserRole? getRole(String roleId) {
    switch (roleId) {
      case 'masterAdmin':
        return UserRole.masterAdmin;
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
        return null;
    }
  }
}

class NoRoleUser {
  UserInfo info;
  AppPermissions permissions;
  NoRoleUser({required this.info}) : permissions = AppPermissions();
}

class Admin {
  UserInfo info;
  AppPermissions permissions;
  Admin({required this.info, required this.permissions});
}

class MasterAdmin {
  UserInfo info;
  AppPermissions permissions;
  MasterAdmin({required this.info})
      : permissions = AppPermissions.masterAdmin();
}

class CompanyManager {
  UserInfo info;
  AppPermissions permissions;
  Company company;
  List<Branch> branches;

  CompanyManager({
    required this.info,
    required this.permissions,
    required this.company,
    required this.branches,
  });
}

class BranchManager {
  UserInfo info;
  AppPermissions permissions;
  Branch branch;

  BranchManager({
    required this.info,
    required this.permissions,
    required this.branch,
  });
}

class Employee {
  UserInfo info;
  AppPermissions permissions;
  Branch branch;

  Employee({
    required this.info,
    required this.permissions,
    required this.branch,
  });
}

class Client {
  UserInfo info;
  AppPermissions permissions;
  Branch branch;

  Client({
    required this.info,
    required this.permissions,
    required this.branch,
  });
}

class Users {
  List<MasterAdmin> masterAdmins = [];
  List<Admin> admins = [];
  List<CompanyManager> companyManagers = [];
  List<BranchManager> branchManagers = [];
  List<Employee> employees = [];
  List<Client> clients = [];
  List<NoRoleUser> noRoleUsers = [];
  List<UserInfo> allUsers = [];
}
