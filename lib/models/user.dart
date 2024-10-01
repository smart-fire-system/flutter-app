import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String countryCode;
  UserRole role;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.countryCode,
      required this.phoneNumber,
      required this.role});

  static String getRoleName(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return S.of(context).admin;
      case UserRole.regionalManager:
        return S.of(context).regionalManager;
      case UserRole.branchManager:
        return S.of(context).branchManager;
      case UserRole.employee:
        return S.of(context).employee;
      case UserRole.technican:
        return S.of(context).technican;
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
      case UserRole.regionalManager:
        return 'regionalManager';
      case UserRole.branchManager:
        return 'branchManager';
      case UserRole.employee:
        return 'employee';
      case UserRole.technican:
        return 'technican';
      case UserRole.client:
        return 'client';
      default:
        return 'none';
    }
  }

  static UserRole getRole(String roleId) {
    switch (roleId) {
      case 'admin':
        return UserRole.admin;
      case 'regionalManager':
        return UserRole.regionalManager;
      case 'branchManager':
        return UserRole.branchManager;
      case 'employee':
        return UserRole.employee;
      case 'technican':
        return UserRole.technican;
      case 'client':
        return UserRole.client;
      default:
        return UserRole.noRole;
    }
  }
}
