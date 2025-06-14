import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/screens/users/bloc/event.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/widgets/dropdown.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  UserRole? _selectedRole;
  NoRoleUser? _selectedUser;
  bool _isSubmitting = false;
  AppPermissions _permissions = AppPermissions(role: UserRole.admin);
  String? _selectedCompanyId;
  String? _selectedBranchId;

  void _onRoleChanged(UserRole? role) {
    setState(() {
      _selectedRole = role;
      _selectedCompanyId = null;
      _selectedBranchId = null;
      // Reset permissions for the new role
      switch (role) {
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
    });
  }

  void _onAddUser(BuildContext context) {
    if (_selectedUser == null || _selectedRole == null) return;
    setState(() {
      _isSubmitting = true;
    });
    context.read<UsersBloc>().add(
          AddRequested(
            userId: _selectedUser!.info.id,
            permissions: _permissions,
            companyId: _selectedCompanyId ?? '',
            branchId: _selectedBranchId ?? '',
          ),
        );
  }

  List<Widget> _buildPermissionCheckboxes() {
    final List<Widget> widgets = [];
    switch (_selectedRole) {
      case UserRole.admin:
        widgets.addAll([
          CheckboxListTile(
            title: const Text('Can update admins'),
            value: _permissions.canUpdateAdmins,
            onChanged: (val) => setState(() {
              _permissions.canUpdateAdmins = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update company managers'),
            value: _permissions.canUpdateCompanyManagers,
            onChanged: (val) => setState(() {
              _permissions.canUpdateCompanyManagers = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update branch managers'),
            value: _permissions.canUpdateBranchManagers,
            onChanged: (val) => setState(() {
              _permissions.canUpdateBranchManagers = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update employees'),
            value: _permissions.canUpdateEmployees,
            onChanged: (val) => setState(() {
              _permissions.canUpdateEmployees = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update clients'),
            value: _permissions.canUpdateClients,
            onChanged: (val) => setState(() {
              _permissions.canUpdateClients = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can add companies'),
            value: _permissions.canAddCompanies,
            onChanged: (val) => setState(() {
              _permissions.canAddCompanies = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit companies'),
            value: _permissions.canEditCompanies,
            onChanged: (val) => setState(() {
              _permissions.canEditCompanies = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can delete companies'),
            value: _permissions.canDeleteCompanies,
            onChanged: (val) => setState(() {
              _permissions.canDeleteCompanies = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can add branches'),
            value: _permissions.canAddBranches,
            onChanged: (val) => setState(() {
              _permissions.canAddBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit branches'),
            value: _permissions.canEditBranches,
            onChanged: (val) => setState(() {
              _permissions.canEditBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can delete branches'),
            value: _permissions.canDeleteBranches,
            onChanged: (val) => setState(() {
              _permissions.canDeleteBranches = val ?? false;
            }),
          ),
        ]);
        break;
      case UserRole.companyManager:
        widgets.addAll([
          CheckboxListTile(
            title: const Text('Can update branch managers'),
            value: _permissions.canUpdateBranchManagers,
            onChanged: (val) => setState(() {
              _permissions.canUpdateBranchManagers = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update employees'),
            value: _permissions.canUpdateEmployees,
            onChanged: (val) => setState(() {
              _permissions.canUpdateEmployees = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update clients'),
            value: _permissions.canUpdateClients,
            onChanged: (val) => setState(() {
              _permissions.canUpdateClients = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can add branches'),
            value: _permissions.canAddBranches,
            onChanged: (val) => setState(() {
              _permissions.canAddBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit branches'),
            value: _permissions.canEditBranches,
            onChanged: (val) => setState(() {
              _permissions.canEditBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can delete branches'),
            value: _permissions.canDeleteBranches,
            onChanged: (val) => setState(() {
              _permissions.canDeleteBranches = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit companies'),
            value: _permissions.canEditCompanies,
            onChanged: (val) => setState(() {
              _permissions.canEditCompanies = val ?? false;
            }),
          ),
        ]);
        break;
      case UserRole.branchManager:
        widgets.addAll([
          CheckboxListTile(
            title: const Text('Can update employees'),
            value: _permissions.canUpdateEmployees,
            onChanged: (val) => setState(() {
              _permissions.canUpdateEmployees = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can update clients'),
            value: _permissions.canUpdateClients,
            onChanged: (val) => setState(() {
              _permissions.canUpdateClients = val ?? false;
            }),
          ),
          CheckboxListTile(
            title: const Text('Can edit branches'),
            value: _permissions.canEditBranches,
            onChanged: (val) => setState(() {
              _permissions.canEditBranches = val ?? false;
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
    final roleItems = UserRole.values
        .where((role) => role != UserRole.masterAdmin)
        .map((role) => CustomDropdownItem(
              title: UserInfo.getRoleName(context, role),
              value: role.toString().split('.').last,
            ))
        .toList();
    return Scaffold(
      appBar: CustomAppBar(title: 'Add User'),
      body: BlocConsumer<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersAuthenticated && _isSubmitting) {
            setState(() {
              _isSubmitting = false;
              _selectedUser = null;
              _selectedCompanyId = null;
              _selectedBranchId = null;
            });
            CustomAlert.showSuccess(
              context: context,
              title: 'Add User',
            );
          } else if (state is UsersLoading) {
            // Optionally show loading
          } else if (state is UsersAuthenticated && state.error != null) {
            setState(() {
              _isSubmitting = false;
            });
            CustomAlert.showError(
              context: context,
              title: 'Add User',
            );
          }
        },
        builder: (context, state) {
          List companies = [];
          List branches = [];
          if (state is UsersAuthenticated) {
            companies = state.companies;
            branches = state.branches;
          }
          final companyItems = companies
              .where((company) => company != null)
              .map((company) => CustomDropdownItem(
                    title: company.name ?? '',
                    value: company.id ?? '',
                  ))
              .toList();
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                child: GestureDetector(
                  onTap: () async {
                    final user = await Navigator.push<NoRoleUser>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoRoleUserSelectionScreen(
                            selectedUser: _selectedUser),
                      ),
                    );
                    if (user != null) {
                      setState(() {
                        _selectedUser = user;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedUser == null
                            ? S.of(context).tapToSelectUser
                            : '${_selectedUser!.info.name} (${_selectedUser!.info.email})',
                      ),
                      decoration: InputDecoration(
                        labelText: S.of(context).user,
                        prefixIcon: const Icon(
                          Icons.person_search,
                          color: CustomStyle.redDark,
                        ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: CustomDropdownSingle(
                  title: S.of(context).role,
                  subtitle: S.of(context).chooseRole,
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
                    final role = UserRole.values.firstWhere(
                        (r) => r.toString().split('.').last == item.value);
                    _onRoleChanged(role);
                  },
                ),
              ),
              if (_selectedRole == UserRole.companyManager ||
                  _selectedRole == UserRole.branchManager)
                Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: CustomDropdownSingle(
                    title: S.of(context).company,
                    subtitle: 'Choose a company',
                    items: companyItems,
                    initialItem: _selectedCompanyId != null
                        ? companyItems.firstWhere(
                            (item) => item.value == _selectedCompanyId,
                            orElse: () =>
                                CustomDropdownItem(title: '', value: ''))
                        : null,
                    onChanged: (item) {
                      setState(() {
                        _selectedCompanyId = item.value;
                        _selectedBranchId = null;
                      });
                    },
                  ),
                ),
              if (_selectedRole == UserRole.branchManager &&
                  _selectedCompanyId != null &&
                  branchItems.isNotEmpty)
                Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: CustomDropdownSingle(
                    title: S.of(context).branch,
                    subtitle: 'Choose a branch',
                    items: branchItems,
                    initialItem: _selectedBranchId != null
                        ? branchItems.firstWhere(
                            (item) => item.value == _selectedBranchId,
                            orElse: () =>
                                CustomDropdownItem(title: '', value: ''))
                        : null,
                    onChanged: (item) {
                      setState(() {
                        _selectedBranchId = item.value;
                      });
                    },
                  ),
                ),
              if (_selectedUser != null &&
                  _selectedRole != null &&
                  (_selectedRole == UserRole.admin ||
                      (_selectedRole == UserRole.companyManager &&
                          _selectedCompanyId != null &&
                          _selectedCompanyId!.isNotEmpty) ||
                      (_selectedRole == UserRole.branchManager &&
                          _selectedCompanyId != null &&
                          _selectedCompanyId!.isNotEmpty &&
                          _selectedBranchId != null &&
                          _selectedBranchId!.isNotEmpty)))
                Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        Text('Permissions',
                            style: Theme.of(context).textTheme.titleMedium),
                        ..._buildPermissionCheckboxes(),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: Text('Add User'),
                  onPressed: _selectedUser == null || _isSubmitting
                      ? null
                      : () => _onAddUser(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NoRoleUserSelectionScreen extends StatefulWidget {
  final NoRoleUser? selectedUser;
  const NoRoleUserSelectionScreen({super.key, this.selectedUser});

  @override
  State<NoRoleUserSelectionScreen> createState() =>
      _NoRoleUserSelectionScreenState();
}

class _NoRoleUserSelectionScreenState extends State<NoRoleUserSelectionScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).selectUsers),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is! UsersAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = state.noRoleUsers.where((user) {
            final q = _search.toLowerCase();
            return user.info.name.toLowerCase().contains(q) ||
                user.info.email.toLowerCase().contains(q) ||
                user.info.code.toString().contains(q) ||
                user.info.phoneNumber.toLowerCase().contains(q);
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: S.of(context).searchBy,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: users.isEmpty
                    ? Center(child: Text(S.of(context).noUsersToView))
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final isSelected = widget.selectedUser != null &&
                              widget.selectedUser!.info.id == user.info.id;
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(user.info.name),
                              subtitle: Text(user.info.email),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                Navigator.pop(context, user);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
