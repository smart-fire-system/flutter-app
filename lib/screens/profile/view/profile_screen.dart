import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/screens/profile/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/event.dart';
import 'package:fire_alarm_system/screens/profile/bloc/state.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/widgets/info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  dynamic _user;
  UserInfo _userInfo = UserInfo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (Route<dynamic> route) => false,
            );
          });
        } else if (state is ProfileAuthenticated) {
          _user = state.user;
          _userInfo = _user.info as UserInfo;
          return _buildProfile(context);
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildProfile(BuildContext context) {
    String selectedCountryCode =
        _userInfo.countryCode == "" ? '+966' : _userInfo.countryCode;

    // Extract company, branch, and permissions if available
    Company? company;
    Branch? branch;
    AppPermissions permissions = _user.permissions as AppPermissions;
    if (_user is CompanyManager) {
      company = _user.company;
    } else if (_user is BranchManager || _user is Employee || _user is Client) {
      branch = _user.branch;
      company = branch?.company;
    }

    List<Widget> permissionBadges =
        _buildRoleBasedPermissionsList(permissions, _user);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).profile),
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(RefreshRequested());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24.0, horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(Icons.account_circle,
                                      size: 64, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _userInfo.name,
                                  style: CustomStyle.mediumTextB
                                      .copyWith(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  UserInfo.getRoleName(
                                      context, _user.permissions.role),
                                  style: CustomStyle.smallText
                                      .copyWith(color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              context
                                  .read<ProfileBloc>()
                                  .add(LogoutRequested());
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 24),
                                const Icon(Icons.logout, color: Colors.red, size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  S.of(context).logout,
                                  style: CustomStyle.smallTextB
                                      .copyWith(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.blueGrey),
                        title: Text(S.of(context).email,
                            style: CustomStyle.smallText),
                        subtitle: Text(_userInfo.email,
                            style: CustomStyle.mediumTextB),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.blueGrey),
                        title: Text(S.of(context).phone,
                            style: CustomStyle.smallText),
                        subtitle: Text(
                            '$selectedCountryCode ${_userInfo.phoneNumber}',
                            style: CustomStyle.mediumTextB),
                      ),
                    ],
                  ),
                ),
                // Company card
                if (company != null) ...[
                  CustomInfoCard(
                    title: S.of(context).company,
                    icon: Icons.business,
                    children: [
                      CustomInfoItem(
                          title: S.of(context).name, value: company.name),
                      CustomInfoItem(
                          title: S.of(context).code,
                          value: company.code?.toString() ?? ''),
                      CustomInfoItem(
                          title: S.of(context).address, value: company.address),
                      CustomInfoItem(
                          title: S.of(context).phone,
                          value: company.phoneNumber),
                      CustomInfoItem(
                          title: S.of(context).email, value: company.email),
                    ],
                  ),
                ],
                // Branch card
                if (branch != null) ...[
                  CustomInfoCard(
                    title: S.of(context).branch,
                    icon: Icons.account_tree_outlined,
                    children: [
                      CustomInfoItem(
                          title: S.of(context).name, value: branch.name),
                      CustomInfoItem(
                          title: S.of(context).code,
                          value: branch.code?.toString() ?? ''),
                      CustomInfoItem(
                          title: S.of(context).address, value: branch.address),
                      CustomInfoItem(
                          title: S.of(context).phone,
                          value: branch.phoneNumber),
                      CustomInfoItem(
                          title: S.of(context).email, value: branch.email),
                    ],
                  ),
                ],
                // Permissions card
                CustomInfoCard(
                  title: 'Permissions',
                  icon: Icons.lock_outline,
                  children: permissionBadges,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TabNavigator.usersAndBranches.currentState?.pushNamed(
            '/profile/update',
          );
        },
        backgroundColor: CustomStyle.redDark,
        tooltip: S.of(context).edit_information,
        child: const Icon(Icons.edit),
      ),
    );
  }

  List<Widget> _buildRoleBasedPermissionsList(
      AppPermissions permissions, dynamic user) {
    final Map<String, List<MapEntry<String, bool>>> grouped = {};
    void addGroup(String group, List<MapEntry<String, bool>> perms) {
      if (perms.isNotEmpty) grouped[group] = perms;
    }

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
