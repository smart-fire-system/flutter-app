import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/info.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/models/permissions.dart';

class UserInfoScreen extends StatelessWidget {
  final String userId;
  const UserInfoScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'User Information'),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is! UsersAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }
          // Find the user by ID in all user lists
          final user = [
            ...state.masterAdmins,
            ...state.admins,
            ...state.companyManagers,
            ...state.branchManagers,
            ...state.employees,
            ...state.clients,
            ...state.noRoleUsers,
          ].cast<dynamic>().firstWhere(
                (u) => u.info.id == userId,
                orElse: () => null,
              );
          if (user == null) {
            return const Center(child: Text('User not found.'));
          }
          final info = user.info;
          final role = user is MasterAdmin
              ? 'Master Admin'
              : user is Admin
                  ? 'Admin'
                  : user is CompanyManager
                      ? 'Company Manager'
                      : user is BranchManager
                          ? 'Branch Manager'
                          : user is Employee
                              ? 'Employee'
                              : user is Client
                                  ? 'Client'
                                  : 'No Role';

          // Get company for all user types
          dynamic company;
          if (user is CompanyManager) {
            company = user.company;
          } else if (user is BranchManager ||
              user is Employee ||
              user is Client) {
            company = user.branch.company;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInfoCard(
                  title: 'User Information',
                  icon: Icons.person_outline,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        // If you have a user image URL, use it here
                        radius: 30,
                        child: Text(info.name.isNotEmpty ? info.name[0] : '?'),
                      ),
                      title: Text(info.name, style: CustomStyle.mediumTextB),
                      subtitle: Text(info.email, style: CustomStyle.smallText),
                    ),
                    CustomInfoItem(
                      title: 'Code',
                      value: info.code.toString(),
                    ),
                    CustomInfoItem(
                      title: 'Phone',
                      value: info.phoneNumber,
                    ),
                    CustomInfoItem(
                      title: 'Role',
                      value: role,
                    ),
                  ],
                ),
                if (company != null)
                  CustomInfoCard(
                    title: 'Company Information',
                    icon: Icons.business_outlined,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/company/details',
                        arguments: company.id,
                      );
                    },
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: Image.network(
                              company.logoURL,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.business),
                            ),
                          ),
                        ),
                        title:
                            Text(company.name, style: CustomStyle.smallTextB),
                        subtitle:
                            Text(company.comment, style: CustomStyle.smallText),
                      ),
                    ],
                  ),
                if (user is BranchManager || user is Employee || user is Client)
                  CustomInfoCard(
                    title: 'Branch Information',
                    icon: Icons.account_tree_outlined,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/branch/details',
                        arguments: user.branch.id,
                      );
                    },
                    children: [
                      CustomInfoItem(
                        title: 'Name',
                        value: user.branch.name,
                      ),
                      CustomInfoItem(
                        title: 'Code',
                        value: user.branch.code?.toString() ?? '',
                      ),
                    ],
                  ),
                CustomInfoCard(
                  title: 'Permissions',
                  icon: Icons.lock_outline,
                  children: [
                    ..._buildRoleBasedPermissionsList(user.permissions, user)
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
        backgroundColor: CustomStyle.redDark,
        onPressed: () {
          TabNavigator.home.currentState?.pushNamed(
            '/user/update',
            arguments: userId,
          );
        },
      ),
    );
  }

  List<Widget> _buildRoleBasedPermissionsList(
      AppPermissions permissions, dynamic user) {
    // Define permission groups and their fields
    final Map<String, List<MapEntry<String, bool>>> grouped = {};
    // Helper to add a group
    void addGroup(String group, List<MapEntry<String, bool>> perms) {
      if (perms.isNotEmpty) grouped[group] = perms;
    }

    // MasterAdmin: show all
    if (user is MasterAdmin) {
      addGroup('Admin Permissions', [
        MapEntry('View Admins', permissions.canViewAdmins),
        MapEntry('Update Admins', permissions.canUpdateAdmins),
      ]);
      addGroup('Company Manager Permissions', [
        MapEntry('View Company Managers', permissions.canViewCompanyManagers),
        MapEntry(
            'Update Company Managers', permissions.canUpdateCompanyManagers),
      ]);
      addGroup('Branch Manager Permissions', [
        MapEntry('View Branch Managers', permissions.canViewBranchManagers),
        MapEntry('Update Branch Managers', permissions.canUpdateBranchManagers),
      ]);
      addGroup('Employee Permissions', [
        MapEntry('View Employees', permissions.canViewEmployees),
        MapEntry('Update Employees', permissions.canUpdateEmployees),
      ]);
      addGroup('Client Permissions', [
        MapEntry('View Clients', permissions.canViewClients),
        MapEntry('Update Clients', permissions.canUpdateClients),
      ]);
      addGroup('Branch Permissions', [
        MapEntry('View Branches', permissions.canViewBranches),
        MapEntry('Edit Branches', permissions.canEditBranches),
        MapEntry('Add Branches', permissions.canAddBranches),
        MapEntry('Delete Branches', permissions.canDeleteBranches),
      ]);
      addGroup('Company Permissions', [
        MapEntry('View Companies', permissions.canViewCompanies),
        MapEntry('Edit Companies', permissions.canEditCompanies),
        MapEntry('Add Companies', permissions.canAddCompanies),
        MapEntry('Delete Companies', permissions.canDeleteCompanies),
      ]);
    } else if (user is Admin) {
      addGroup('Admin Permissions', [
        MapEntry('View Admins', permissions.canViewAdmins),
        MapEntry('Update Admins', permissions.canUpdateAdmins),
      ]);
      addGroup('Company Manager Permissions', [
        MapEntry('View Company Managers', permissions.canViewCompanyManagers),
        MapEntry(
            'Update Company Managers', permissions.canUpdateCompanyManagers),
      ]);
      addGroup('Branch Manager Permissions', [
        MapEntry('View Branch Managers', permissions.canViewBranchManagers),
        MapEntry('Update Branch Managers', permissions.canUpdateBranchManagers),
      ]);
      addGroup('Employee Permissions', [
        MapEntry('View Employees', permissions.canViewEmployees),
        MapEntry('Update Employees', permissions.canUpdateEmployees),
      ]);
      addGroup('Client Permissions', [
        MapEntry('View Clients', permissions.canViewClients),
        MapEntry('Update Clients', permissions.canUpdateClients),
      ]);
      addGroup('Branch Permissions', [
        MapEntry('View Branches', permissions.canViewBranches),
        MapEntry('Edit Branches', permissions.canEditBranches),
        MapEntry('Add Branches', permissions.canAddBranches),
        MapEntry('Delete Branches', permissions.canDeleteBranches),
      ]);
      addGroup('Company Permissions', [
        MapEntry('View Companies', permissions.canViewCompanies),
        MapEntry('Edit Companies', permissions.canEditCompanies),
        MapEntry('Add Companies', permissions.canAddCompanies),
        MapEntry('Delete Companies', permissions.canDeleteCompanies),
      ]);
    } else if (user is CompanyManager) {
      addGroup('Branch Manager Permissions', [
        MapEntry('View Branch Managers', permissions.canViewBranchManagers),
        MapEntry('Update Branch Managers', permissions.canUpdateBranchManagers),
      ]);
      addGroup('Employee Permissions', [
        MapEntry('View Employees', permissions.canViewEmployees),
        MapEntry('Update Employees', permissions.canUpdateEmployees),
      ]);
      addGroup('Client Permissions', [
        MapEntry('View Clients', permissions.canViewClients),
        MapEntry('Update Clients', permissions.canUpdateClients),
      ]);
      addGroup('Branch Permissions', [
        MapEntry('View Branches', permissions.canViewBranches),
        MapEntry('Edit Branches', permissions.canEditBranches),
        MapEntry('Add Branches', permissions.canAddBranches),
        MapEntry('Delete Branches', permissions.canDeleteBranches),
      ]);
      addGroup('Company Permissions', [
        MapEntry('View Companies', permissions.canViewCompanies),
        MapEntry('Edit Companies', permissions.canEditCompanies),
      ]);
    } else if (user is BranchManager) {
      addGroup('Employee Permissions', [
        MapEntry('View Employees', permissions.canViewEmployees),
        MapEntry('Update Employees', permissions.canUpdateEmployees),
      ]);
      addGroup('Client Permissions', [
        MapEntry('View Clients', permissions.canViewClients),
        MapEntry('Update Clients', permissions.canUpdateClients),
      ]);
      addGroup('Branch Permissions', [
        MapEntry('View Branches', permissions.canViewBranches),
        MapEntry('Edit Branches', permissions.canEditBranches),
      ]);
      addGroup('Company Permissions', [
        MapEntry('View Companies', permissions.canViewCompanies),
      ]);
    } else if (user is Employee) {
      addGroup('Client Permissions', [
        MapEntry('View Clients', permissions.canViewClients),
        MapEntry('Update Clients', permissions.canUpdateClients),
      ]);
      addGroup('Branch Permissions', [
        MapEntry('View Branches', permissions.canViewBranches),
      ]);
      addGroup('Company Permissions', [
        MapEntry('View Companies', permissions.canViewCompanies),
      ]);
    } else if (user is Client) {
      addGroup('Branch Permissions', [
        MapEntry('View Branches', permissions.canViewBranches),
      ]);
    }

    // UI: Grouped with section headers and colored badges
    List<Widget> widgets = [];
    grouped.forEach((group, perms) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
        child: Text(group, style: CustomStyle.mediumTextBRed),
      ));
      widgets.add(Wrap(
        spacing: 12,
        runSpacing: 4,
        children: perms
            .map((entry) => _permissionBadge(entry.key, entry.value))
            .toList(),
      ));
    });
    if (widgets.isEmpty) {
      widgets.add(const Text('No permissions.'));
    }
    return widgets;
  }

  Widget _permissionBadge(String label, bool value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: value ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: value ? Colors.green : Colors.red, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(value ? Icons.check_circle : Icons.cancel,
              size: 16, color: value ? Colors.green : Colors.red),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: value ? Colors.green[900] : Colors.red[900],
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
