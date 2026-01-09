import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/screens/users/bloc/event.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/widgets/dropdown.dart';
import 'package:fire_alarm_system/widgets/selection_screen.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  const UpdateUserScreen({super.key, required this.userId});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  UserRole? _selectedRole;
  dynamic _user;
  AppPermissions? _permissions;
  String? _selectedCompanyId;
  String? _selectedBranchId;
  String? _selectedCompanyName;
  String? _selectedBranchName;
  bool _loading = true;
  final Map<UserRole, AppPermissions> _originalPermissions = {};

  @override
  void initState() {
    super.initState();
    // Prefill user data after first build
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillUserData());
  }

  void _prefillUserData() {
    final state = context.read<UsersBloc>().state;
    if (state is! UsersAuthenticated) return;
    final user = [
      ...state.masterAdmins,
      ...state.admins,
      ...state.companyManagers,
      ...state.branchManagers,
      ...state.employees,
      ...state.clients,
      ...state.noRoleUsers,
    ]
        .cast<dynamic>()
        .firstWhere((u) => u.info.id == widget.userId, orElse: () => null);
    if (user == null) return;
    setState(() {
      _user = user;
      _selectedRole = _getRole(user);
      _permissions = user.permissions;
      if (_selectedRole != null &&
          !_originalPermissions.containsKey(_selectedRole)) {
        _originalPermissions[_selectedRole!] =
            _clonePermissions(user.permissions);
      }
      if (user is CompanyManager) {
        _selectedCompanyId = user.company.id;
        _selectedCompanyName = user.company.name;
      } else if (user is BranchManager || user is Employee || user is Client) {
        _selectedCompanyId = user.branch.company.id;
        _selectedCompanyName = user.branch.company.name;
        _selectedBranchId = user.branch.id;
        _selectedBranchName = user.branch.name;
      }
      _loading = false;
    });
  }

  AppPermissions _clonePermissions(AppPermissions perms) {
    return AppPermissions(
      role: perms.role,
      canViewAdmins: perms.canViewAdmins,
      canUpdateAdmins: perms.canUpdateAdmins,
      canViewCompanyManagers: perms.canViewCompanyManagers,
      canUpdateCompanyManagers: perms.canUpdateCompanyManagers,
      canViewBranchManagers: perms.canViewBranchManagers,
      canUpdateBranchManagers: perms.canUpdateBranchManagers,
      canViewEmployees: perms.canViewEmployees,
      canUpdateEmployees: perms.canUpdateEmployees,
      canViewClients: perms.canViewClients,
      canUpdateClients: perms.canUpdateClients,
      canViewBranches: perms.canViewBranches,
      canEditBranches: perms.canEditBranches,
      canAddBranches: perms.canAddBranches,
      canDeleteBranches: perms.canDeleteBranches,
      canViewCompanies: perms.canViewCompanies,
      canEditCompanies: perms.canEditCompanies,
      canAddCompanies: perms.canAddCompanies,
      canDeleteCompanies: perms.canDeleteCompanies,
    );
  }

  UserRole? _getRole(dynamic user) {
    if (user is MasterAdmin) return UserRole.masterAdmin;
    if (user is Admin) return UserRole.admin;
    if (user is CompanyManager) return UserRole.companyManager;
    if (user is BranchManager) return UserRole.branchManager;
    if (user is Employee) return UserRole.employee;
    if (user is Client) return UserRole.client;
    return null;
  }

  void _onRoleChanged(UserRole? role) {
    setState(() {
      _selectedRole = role;
      _selectedCompanyId = null;
      _selectedBranchId = null;
      if (role != null && _originalPermissions.containsKey(role)) {
        _permissions = _clonePermissions(_originalPermissions[role]!);
      } else {
        switch (role) {
          case UserRole.masterAdmin:
            _permissions = AppPermissions.masterAdmin();
            break;
          case UserRole.admin:
            _permissions = AppPermissions(role: UserRole.admin);
            break;
          case UserRole.companyManager:
            _permissions = AppPermissions(role: UserRole.companyManager);
            break;
          case UserRole.branchManager:
            _permissions = AppPermissions(role: UserRole.branchManager);
            break;
          case UserRole.employee:
            _permissions = AppPermissions(role: UserRole.employee);
            break;
          case UserRole.client:
            _permissions = AppPermissions(role: UserRole.client);
            break;
          default:
            _permissions = AppPermissions();
        }
      }
    });
  }

  void _onSave(BuildContext context) async {
    if (_user == null || _selectedRole == null || _permissions == null) return;
    final pressedValue = await CustomAlert.showConfirmation(
      context: context,
      title: 'Save User',
      subtitle: 'Are you sure you want to save this user?',
      buttons: [
        CustomAlertConfirmationButton(
          title: 'Save',
          value: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        ),
        CustomAlertConfirmationButton(
          title: 'Cancel',
          value: 0,
          backgroundColor: CustomStyle.greyMedium,
          textColor: Colors.white,
        ),
      ],
    );
    if (pressedValue == 1 && context.mounted) {
      context.read<UsersBloc>().add(
            ModifyRequested(
              userId: _user.info.id,
              permissions: _permissions!,
              companyId: _selectedCompanyId ?? '',
              branchId: _selectedBranchId ?? '',
            ),
          );
    }
  }

  List<Widget> _buildPermissionCheckboxes() {
    final List<Widget> widgets = [];
    switch (_selectedRole) {
      case UserRole.admin:
        widgets.addAll([
          CheckboxListTile(
            title: const Text('Can update admins'),
            value: _permissions!.canUpdateAdmins,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateAdmins = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update company managers'),
            value: _permissions!.canUpdateCompanyManagers,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateCompanyManagers = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update branch managers'),
            value: _permissions!.canUpdateBranchManagers,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateBranchManagers = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update employees'),
            value: _permissions!.canUpdateEmployees,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateEmployees = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update clients'),
            value: _permissions!.canUpdateClients,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateClients = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can add companies'),
            value: _permissions!.canAddCompanies,
            onChanged: (val) => setState(() {
              _permissions!.canAddCompanies = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit companies'),
            value: _permissions!.canEditCompanies,
            onChanged: (val) => setState(() {
              _permissions!.canEditCompanies = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can delete companies'),
            value: _permissions!.canDeleteCompanies,
            onChanged: (val) => setState(() {
              _permissions!.canDeleteCompanies = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can add branches'),
            value: _permissions!.canAddBranches,
            onChanged: (val) => setState(() {
              _permissions!.canAddBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit branches'),
            value: _permissions!.canEditBranches,
            onChanged: (val) => setState(() {
              _permissions!.canEditBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can delete branches'),
            value: _permissions!.canDeleteBranches,
            onChanged: (val) => setState(() {
              _permissions!.canDeleteBranches = val ?? false;
            }),
          ),
        ]);
        break;
      case UserRole.companyManager:
        widgets.addAll([
          CheckboxListTile(
            title: const Text('Can update branch managers'),
            value: _permissions!.canUpdateBranchManagers,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateBranchManagers = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update employees'),
            value: _permissions!.canUpdateEmployees,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateEmployees = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update clients'),
            value: _permissions!.canUpdateClients,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateClients = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can add branches'),
            value: _permissions!.canAddBranches,
            onChanged: (val) => setState(() {
              _permissions!.canAddBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit branches'),
            value: _permissions!.canEditBranches,
            onChanged: (val) => setState(() {
              _permissions!.canEditBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can delete branches'),
            value: _permissions!.canDeleteBranches,
            onChanged: (val) => setState(() {
              _permissions!.canDeleteBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit companies'),
            value: _permissions!.canEditCompanies,
            onChanged: (val) => setState(() {
              _permissions!.canEditCompanies = val ?? false;
            }),
          ),
        ]);
        break;
      case UserRole.branchManager:
        widgets.addAll([
          CheckboxListTile(
            title: const Text('Can update employees'),
            value: _permissions!.canUpdateEmployees,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateEmployees = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update clients'),
            value: _permissions!.canUpdateClients,
            onChanged: (val) => setState(() {
              _permissions!.canUpdateClients = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit branches'),
            value: _permissions!.canEditBranches,
            onChanged: (val) => setState(() {
              _permissions!.canEditBranches = val ?? false;
            }),
          ),
        ]);
        break;
      default:
        widgets.add(const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('No permissions for this role.'),
        ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : BlocConsumer<UsersBloc, UsersState>(
            listener: (context, state) {
              if (state is UsersAuthenticated && state.message != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await CustomAlert.showSuccess(
                    context: context,
                    title: state.message!.getText(context),
                  );
                  if (context.mounted) Navigator.pop(context);
                });
              }
            },
            builder: (context, state) {
              List branches = [];
              if (state is UsersAuthenticated) {
                branches = state.branches;
                final branchItems = branches
                    .where((branch) =>
                        branch != null &&
                        branch.company != null &&
                        branch.company.id == _selectedCompanyId)
                    .map((branch) => CustomDropdownItem(
                          title: branch.name ?? '',
                          value: branch.id ?? '',
                        ))
                    .toList();
                final List<UserRole> allowedRoles = [
                  UserRole.masterAdmin,
                  UserRole.admin,
                  UserRole.companyManager,
                  UserRole.branchManager,
                  UserRole.employee,
                  UserRole.client,
                ];
                final roleItems = allowedRoles
                    .map((role) => CustomDropdownItem(
                          title: UserInfo.getRoleName(context, role),
                          value: role.toString().split('.').last,
                        ))
                    .toList();
                return Scaffold(
                  appBar: const CustomAppBar(title: 'Update User'),
                  body: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                        child: CustomDropdownSingle(
                          title: l10n.role,
                          subtitle: l10n.chooseRole,
                          items: roleItems,
                          initialItem: _selectedRole != null
                              ? roleItems.firstWhere(
                                  (item) =>
                                      item.value ==
                                      _selectedRole.toString().split('.').last,
                                  orElse: () =>
                                      CustomDropdownItem(title: '', value: ''))
                              : null,
                          onChanged: (item) {
                            final role = UserRole.values.firstWhere((r) =>
                                r.toString().split('.').last == item.value);
                            _onRoleChanged(role);
                          },
                        ),
                      ),
                      if (_selectedRole == UserRole.companyManager ||
                          _selectedRole == UserRole.branchManager ||
                          _selectedRole == UserRole.employee ||
                          _selectedRole == UserRole.client)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              List<Company> companies = state.companies;
                              final company = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanySelectionScreen(
                                    selectedCompanyId: _selectedCompanyId,
                                    companies: companies,
                                  ),
                                ),
                              );
                              if (company != null) {
                                setState(() {
                                  _selectedCompanyId = company.id;
                                  _selectedCompanyName = company.name;
                                  _selectedBranchId = null;
                                  _selectedBranchName = null;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: _selectedCompanyId == null
                                      ? l10n.tapToSelectUser
                                      : _selectedCompanyName ?? '',
                                ),
                                decoration: InputDecoration(
                                  labelText: l10n.company,
                                  prefixIcon: const Icon(Icons.business,
                                      color: CustomStyle.redDark),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                      color: CustomStyle.greyLight,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                      color: CustomStyle.greyLight,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                      color: CustomStyle.redDark,
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: const Icon(Icons.edit),
                                  labelStyle: CustomStyle.mediumTextBRed,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      if ((_selectedRole == UserRole.branchManager ||
                              _selectedRole == UserRole.employee ||
                              _selectedRole == UserRole.client) &&
                          _selectedCompanyId != null &&
                          branchItems.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              List<Branch> branches = state.branches;
                              final branch = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BranchSelectionScreen(
                                    companyId: _selectedCompanyId!,
                                    selectedBranchId: _selectedBranchId,
                                    branches: branches,
                                  ),
                                ),
                              );
                              if (branch != null) {
                                setState(() {
                                  _selectedBranchId = branch.id;
                                  _selectedBranchName = branch.name;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: _selectedBranchId == null
                                      ? l10n.tapToSelectUser
                                      : _selectedBranchName ?? '',
                                ),
                                decoration: InputDecoration(
                                  labelText: l10n.branch,
                                  prefixIcon: const Icon(Icons.account_tree,
                                      color: CustomStyle.redDark),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                      color: CustomStyle.greyLight,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                      color: CustomStyle.greyLight,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                      color: CustomStyle.redDark,
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: const Icon(Icons.edit),
                                  labelStyle: CustomStyle.mediumTextBRed,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      if (_selectedRole != null)
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            child: ListView(
                              children: [
                                const SizedBox(height: 8),
                                Text('Permissions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                if (_selectedRole == UserRole.masterAdmin)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Master Admin has all permissions.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  )
                                else
                                  ..._buildPermissionCheckboxes(),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    backgroundColor: _isSaveEnabled() == null
                        ? Colors.green
                        : CustomStyle.greyMedium,
                    onPressed: _isSaveEnabled() == null
                        ? () => _onSave(context)
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isSaveEnabled()!),
                                backgroundColor: Colors.orange,
                                duration: const Duration(seconds: 2),
                                showCloseIcon: true,
                              ),
                            );
                          },
                  ),
                );
              }
              return const CustomLoading();
            },
          );
  }

  String? _isSaveEnabled() {
    if (_selectedRole == null) {
      return "Please select a role";
    }
    if (_selectedCompanyId == null &&
        (_selectedRole == UserRole.companyManager ||
            _selectedRole == UserRole.branchManager ||
            _selectedRole == UserRole.employee ||
            _selectedRole == UserRole.client)) {
      return "Please select a company";
    }
    if (_selectedBranchId == null &&
        (_selectedRole == UserRole.branchManager ||
            _selectedRole == UserRole.employee ||
            _selectedRole == UserRole.client)) {
      return "Please select a branch";
    }
    return null;
  }
}
