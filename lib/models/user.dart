import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/premissions.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter/material.dart';

class UserInfo {
  String id;
  String name;
  String email;
  String phoneNumber;
  String countryCode;
  Timestamp? createdAt;

  UserInfo({
    this.id = "",
    this.name = "",
    this.email = "",
    this.countryCode = "",
    this.phoneNumber = "",
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
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
    );
  }

  static String getRoleName(BuildContext context, UserRole? role) {
    switch (role) {
      case UserRole.admin:
      case UserRole.masterAdmin:
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
  AppPremessions premissions;
  NoRoleUser({required this.info}) : premissions = AppPremessions();
}

class Admin {
  UserInfo info;
  AppPremessions premissions;
  Admin({required this.info, required this.premissions});
}

class MasterAdmin {
  UserInfo info;
  AppPremessions premissions;
  MasterAdmin({required this.info})
      : premissions = AppPremessions.masterAdmin();
}

class CompanyManager {
  UserInfo info;
  AppPremessions premissions;
  Company company;
  List<Branch> branches;

  CompanyManager({
    required this.info,
    required this.premissions,
    required this.company,
    required this.branches,
  });
}

class BranchManager {
  UserInfo info;
  AppPremessions premissions;
  Branch branch;

  BranchManager({
    required this.info,
    required this.premissions,
    required this.branch,
  });
}

class Employee {
  UserInfo info;
  AppPremessions premissions;
  Branch branch;

  Employee({
    required this.info,
    required this.premissions,
    required this.branch,
  });
}

class Client {
  UserInfo info;
  AppPremessions premissions;
  Branch branch;

  Client({
    required this.info,
    required this.premissions,
    required this.branch,
  });
}
