import 'package:fire_alarm_system/utils/enums.dart';

class AppPermissions {
  UserRole? role;

  bool canViewAdmins;
  bool canEditAdmins;
  bool canAddAdmins;
  bool canDeleteAdmins;

  bool canViewCompanyManagers;
  bool canEditCompanyManagers;
  bool canAddCompanyManagers;
  bool canDeleteCompanyManagers;

  bool canViewBranchManagers;
  bool canEditBranchManagers;
  bool canAddBranchManagers;
  bool canDeleteBranchManagers;

  bool canViewEmployees;
  bool canEditEmployees;
  bool canAddEmployees;
  bool canDeleteEmployees;

  bool canViewClients;
  bool canEditClients;
  bool canAddClients;
  bool canDeleteClients;

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
    this.canEditAdmins = false,
    this.canAddAdmins = false,
    this.canDeleteAdmins = false,
    this.canViewCompanyManagers = false,
    this.canEditCompanyManagers = false,
    this.canAddCompanyManagers = false,
    this.canDeleteCompanyManagers = false,
    this.canViewBranchManagers = false,
    this.canEditBranchManagers = false,
    this.canAddBranchManagers = false,
    this.canDeleteBranchManagers = false,
    this.canViewEmployees = false,
    this.canEditEmployees = false,
    this.canAddEmployees = false,
    this.canDeleteEmployees = false,
    this.canViewClients = false,
    this.canEditClients = false,
    this.canAddClients = false,
    this.canDeleteClients = false,
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
      canEditAdmins: true,
      canAddAdmins: true,
      canDeleteAdmins: true,
      canViewCompanyManagers: true,
      canEditCompanyManagers: true,
      canAddCompanyManagers: true,
      canDeleteCompanyManagers: true,
      canViewBranchManagers: true,
      canEditBranchManagers: true,
      canAddBranchManagers: true,
      canDeleteBranchManagers: true,
      canViewEmployees: true,
      canEditEmployees: true,
      canAddEmployees: true,
      canDeleteEmployees: true,
      canViewClients: true,
      canEditClients: true,
      canAddClients: true,
      canDeleteClients: true,
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
      canEditAdmins: map['canEditAdmins'] ?? false,
      canAddAdmins: map['canAddAdmins'] ?? false,
      canDeleteAdmins: map['canDeleteAdmins'] ?? false,
      canViewCompanyManagers: true,
      canEditCompanyManagers: map['canEditCompanyManagers'] ?? false,
      canAddCompanyManagers: map['canAddCompanyManagers'] ?? false,
      canDeleteCompanyManagers: map['canDeleteCompanyManagers'] ?? false,
      canViewBranchManagers: true,
      canEditBranchManagers: map['canEditBranchManagers'] ?? false,
      canAddBranchManagers: map['canAddBranchManagers'] ?? false,
      canDeleteBranchManagers: map['canDeleteBranchManagers'] ?? false,
      canViewEmployees: true,
      canEditEmployees: map['canEditEmployees'] ?? false,
      canAddEmployees: map['canAddEmployees'] ?? false,
      canDeleteEmployees: map['canDeleteEmployees'] ?? false,
      canViewClients: true,
      canEditClients: map['canEditClients'] ?? false,
      canAddClients: map['canAddClients'] ?? false,
      canDeleteClients: map['canDeleteClients'] ?? false,
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

  factory AppPermissions.fromCompanyManagerMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.companyManager,
      canViewBranchManagers: true,
      canEditBranchManagers: map['canEditBranchManagers'] ?? false,
      canAddBranchManagers: map['canAddBranchManagers'] ?? false,
      canDeleteBranchManagers: map['canDeleteBranchManagers'] ?? false,
      canViewEmployees: true,
      canEditEmployees: map['canEditEmployees'] ?? false,
      canAddEmployees: map['canAddEmployees'] ?? false,
      canDeleteEmployees: map['canDeleteEmployees'] ?? false,
      canViewClients: true,
      canEditClients: map['canEditClients'] ?? false,
      canAddClients: map['canAddClients'] ?? false,
      canDeleteClients: map['canDeleteClients'] ?? false,
      canViewBranches: true,
      canEditBranches: map['canEditBranches'] ?? false,
      canAddBranches: map['canAddBranches'] ?? false,
      canDeleteBranches: map['canDeleteBranches'] ?? false,
      canViewCompanies: true,
      canEditCompanies: map['canEditCompanies'] ?? false,
    );
  }

  factory AppPermissions.fromBranchManagerMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.branchManager,
      canViewEmployees: true,
      canEditEmployees: map['canEditEmployees'] ?? false,
      canAddEmployees: map['canAddEmployees'] ?? false,
      canDeleteEmployees: map['canDeleteEmployees'] ?? false,
      canViewClients: true,
      canEditClients: map['canEditClients'] ?? false,
      canAddClients: map['canAddClients'] ?? false,
      canDeleteClients: map['canDeleteClients'] ?? false,
      canViewBranches: true,
      canEditBranches: map['canEditBranches'] ?? false,
    );
  }

  factory AppPermissions.fromEmployeeMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.branchManager,
      canViewClients: true,
      canEditClients: map['canEditClients'] ?? false,
      canAddClients: map['canAddClients'] ?? false,
      canDeleteClients: map['canDeleteClients'] ?? false,
    );
  }

  factory AppPermissions.fromClientMap(Map<String, dynamic> map) {
    return AppPermissions(
      role: UserRole.branchManager,
    );
  }
}
