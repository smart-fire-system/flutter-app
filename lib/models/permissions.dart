import 'package:fire_alarm_system/utils/enums.dart';

class AppPermissions {
  UserRole? role;

  bool canViewAdmins;
  bool canUpdateAdmins;

  bool canViewCompanyManagers;
  bool canUpdateCompanyManagers;

  bool canViewBranchManagers;
  bool canUpdateBranchManagers;

  bool canViewEmployees;
  bool canUpdateEmployees;

  bool canViewClients;
  bool canUpdateClients;

  bool canViewBranches;
  bool canEditBranches;
  bool canAddBranches;
  bool canDeleteBranches;

  bool canViewCompanies;
  bool canEditCompanies;
  bool canAddCompanies;
  bool canDeleteCompanies;

  AppPermissions({
    this.role,
    this.canViewAdmins = false,
    this.canUpdateAdmins = false,
    this.canViewCompanyManagers = false,
    this.canUpdateCompanyManagers = false,
    this.canViewBranchManagers = false,
    this.canUpdateBranchManagers = false,
    this.canViewEmployees = false,
    this.canUpdateEmployees = false,
    this.canViewClients = false,
    this.canUpdateClients = false,
    this.canViewBranches = false,
    this.canEditBranches = false,
    this.canAddBranches = false,
    this.canDeleteBranches = false,
    this.canViewCompanies = false,
    this.canEditCompanies = false,
    this.canAddCompanies = false,
    this.canDeleteCompanies = false,
  });

  factory AppPermissions.masterAdmin() {
    return AppPermissions(
      role: UserRole.masterAdmin,
      canViewAdmins: true,
      canUpdateAdmins: true,
      canViewCompanyManagers: true,
      canUpdateCompanyManagers: true,
      canViewBranchManagers: true,
      canUpdateBranchManagers: true,
      canViewEmployees: true,
      canUpdateEmployees: true,
      canViewClients: true,
      canUpdateClients: true,
      canViewBranches: true,
      canEditBranches: true,
      canAddBranches: true,
      canDeleteBranches: true,
      canViewCompanies: true,
      canEditCompanies: true,
      canAddCompanies: true,
      canDeleteCompanies: true,
    );
  }

  factory AppPermissions.fromAdminMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.admin,
      canViewAdmins: true,
      canUpdateAdmins: map['canUpdateAdmins'] ?? false,
      canViewCompanyManagers: true,
      canUpdateCompanyManagers: map['canUpdateCompanyManagers'] ?? false,
      canViewBranchManagers: true,
      canUpdateBranchManagers: map['canUpdateBranchManagers'] ?? false,
      canViewEmployees: true,
      canUpdateEmployees: map['canUpdateEmployees'] ?? false,
      canViewClients: true,
      canUpdateClients: map['canUpdateClients'] ?? false,
      canViewBranches: true,
      canEditBranches: map['canEditBranches'] ?? false,
      canAddBranches: map['canAddBranches'] ?? false,
      canDeleteBranches: map['canDeleteBranches'] ?? false,
      canViewCompanies: true,
      canEditCompanies: map['canEditCompanies'] ?? false,
      canAddCompanies: map['canAddCompanies'] ?? false,
      canDeleteCompanies: map['canDeleteCompanies'] ?? false,
    );
  }

  Map<String, dynamic> toAdminMap(AppPermissions permissions) {
    return {
      'permissions': {
        'canUpdateAdmins': permissions.canUpdateAdmins,
        'canUpdateCompanyManagers': permissions.canUpdateCompanyManagers,
        'canUpdateBranchManagers': permissions.canUpdateBranchManagers,
        'canUpdateEmployees': permissions.canUpdateEmployees,
        'canUpdateClients': permissions.canUpdateClients,
        'canAddCompanies': permissions.canAddCompanies,
        'canEditCompanies': permissions.canEditCompanies,
        'canDeleteCompanies': permissions.canDeleteCompanies,
        'canAddBranches': permissions.canAddBranches,
        'canEditBranches': permissions.canEditBranches,
        'canDeleteBranches': permissions.canDeleteBranches,
      },
    };
  }

  factory AppPermissions.fromCompanyManagerMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.companyManager,
      canViewBranchManagers: true,
      canUpdateBranchManagers: map['canUpdateBranchManagers'] ?? false,
      canViewEmployees: true,
      canUpdateEmployees: map['canUpdateEmployees'] ?? false,
      canViewClients: true,
      canUpdateClients: map['canUpdateClients'] ?? false,
      canViewBranches: true,
      canEditBranches: map['canEditBranches'] ?? false,
      canAddBranches: map['canAddBranches'] ?? false,
      canDeleteBranches: map['canDeleteBranches'] ?? false,
      canViewCompanies: true,
      canEditCompanies: map['canEditCompanies'] ?? false,
    );
  }

  Map<String, dynamic> toCompanyManagerMap(
      AppPermissions permissions, String companyId) {
    return {
      'company': companyId,
      'permissions': {
        'canUpdateBranchManagers': permissions.canUpdateBranchManagers,
        'canUpdateEmployees': permissions.canUpdateEmployees,
        'canUpdateClients': permissions.canUpdateClients,
        'canAddBranches': permissions.canAddBranches,
        'canEditBranches': permissions.canEditBranches,
        'canDeleteBranches': permissions.canDeleteBranches,
      },
    };
  }

  factory AppPermissions.fromBranchManagerMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.branchManager,
      canViewEmployees: true,
      canUpdateEmployees: map['canUpdateEmployees'] ?? false,
      canViewClients: true,
      canUpdateClients: map['canUpdateClients'] ?? false,
      canViewBranches: true,
      canEditBranches: map['canEditBranches'] ?? false,
      canViewCompanies: true,
    );
  }

  Map<String, dynamic> toBranchManagerMap(
      AppPermissions permissions, String branchId, String companyId) {
    return {
      'branch': branchId,
      'company': companyId,
      'permissions': {
        'canUpdateEmployees': permissions.canUpdateEmployees,
        'canUpdateClients': permissions.canUpdateClients,
        'canEditBranches': permissions.canEditBranches,
      },
    };
  }

  factory AppPermissions.fromEmployeeMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.employee,
      canViewClients: true,
      canUpdateClients: map['canUpdateClients'] ?? false,
      canViewBranches: true,
      canViewCompanies: true,
    );
  }

  Map<String, dynamic> toEmployeeMap(
      AppPermissions permissions, String branchId, String companyId) {
    return {
      'branch': branchId,
      'company': companyId,
      'permissions': {
        'canUpdateClients': permissions.canUpdateClients,
      },
    };
  }

  factory AppPermissions.fromClientMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.client,
      canViewBranches: true,
      canViewCompanies: true,
    );
  }

  Map<String, dynamic> toClientMap(
      AppPermissions permissions, String branchId, String companyId) {
    return {
      'branch': branchId,
      'company': companyId,
      'permissions': {},
    };
  }
}
