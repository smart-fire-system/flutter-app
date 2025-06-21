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
  const AddUserScreen({super.key});

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
  String? _selectedCompanyName;
  String? _selectedBranchName;

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
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is! UsersAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final permissions = state.roleUser.permissions as AppPermissions;
        final canUpdate = [
          permissions.canUpdateAdmins,
          permissions.canUpdateCompanyManagers,
          permissions.canUpdateBranchManagers,
          permissions.canUpdateEmployees,
          permissions.canUpdateClients,
        ];
        if (!canUpdate.any((p) => p)) {
          return Scaffold(
            appBar: const CustomAppBar(title: 'Add User'),
            body: Center(
              child: Text(
                'You do not have permission to add users.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }
        // Only show roles the user can set
        final List<UserRole> allowedRoles = [];
        if (permissions.canUpdateAdmins) allowedRoles.add(UserRole.admin);
        if (permissions.canUpdateCompanyManagers)
          allowedRoles.add(UserRole.companyManager);
        if (permissions.canUpdateBranchManagers)
          allowedRoles.add(UserRole.branchManager);
        if (permissions.canUpdateEmployees) allowedRoles.add(UserRole.employee);
        if (permissions.canUpdateClients) allowedRoles.add(UserRole.client);
        final roleItems = allowedRoles
            .map((role) => CustomDropdownItem(
                  title: UserInfo.getRoleName(context, role),
                  value: role.toString().split('.').last,
                ))
            .toList();
        return Scaffold(
          appBar: const CustomAppBar(title: 'Add User'),
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
              List branches = [];
              if (state is UsersAuthenticated) {
                branches = state.branches;
              }
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
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        final usersBlocState = context.read<UsersBloc>().state;
                        final result =
                            await Navigator.push<_UserSelectionResult>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSelectionScreen(
                              selectedUserId: _selectedUser?.info.id,
                            ),
                          ),
                        );
                        if (!mounted) return;
                        if (result != null &&
                            usersBlocState is UsersAuthenticated) {
                          final selected = usersBlocState.noRoleUsers
                                  .where((u) => u.info.id == result.id)
                                  .isNotEmpty
                              ? usersBlocState.noRoleUsers
                                  .firstWhere((u) => u.info.id == result.id)
                              : null;
                          setState(() {
                            _selectedUser = selected;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _selectedUser == null
                                ? S.of(context).tapToSelectUser
                                : _selectedUser!.info.name,
                          ),
                          decoration: InputDecoration(
                            labelText: S.of(context).user,
                            prefixIcon: const Icon(Icons.person,
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
                  if (_selectedRole == UserRole.companyManager ||
                      _selectedRole == UserRole.branchManager ||
                      _selectedRole == UserRole.employee ||
                      _selectedRole == UserRole.client)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          final company =
                              await Navigator.push<_CompanySelectionResult>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanySelectionScreen(
                                selectedCompanyId: _selectedCompanyId,
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
                                  ? S.of(context).tapToSelectUser
                                  : _selectedCompanyName ?? '',
                            ),
                            decoration: InputDecoration(
                              labelText: S.of(context).company,
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
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          final branch =
                              await Navigator.push<_BranchSelectionResult>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchSelectionScreen(
                                companyId: _selectedCompanyId!,
                                selectedBranchId: _selectedBranchId,
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
                                  ? S.of(context).tapToSelectUser
                                  : _selectedBranchName ?? '',
                            ),
                            decoration: InputDecoration(
                              labelText: S.of(context).branch,
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
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
                      label: const Text('Add User'),
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
      },
    );
  }
}

class _UserSelectionResult {
  final String id;
  final String name;
  _UserSelectionResult({required this.id, required this.name});
}

class UserSelectionScreen extends StatelessWidget {
  final String? selectedUserId;
  const UserSelectionScreen({super.key, this.selectedUserId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is! UsersAuthenticated) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final users = state.noRoleUsers;
        return _SelectionScreen<_UserSelectionResult>(
          title: S.of(context).user,
          items: users
              .map((user) => _SelectionItem(
                    id: user.info.id,
                    name: user.info.name,
                    code: user.info.code.toString(),
                    email: user.info.email,
                  ))
              .toList(),
          selectedId: selectedUserId,
          onSelect: (item) {
            Navigator.pop(
                context, _UserSelectionResult(id: item.id, name: item.name));
          },
        );
      },
    );
  }
}

class _CompanySelectionResult {
  final String id;
  final String name;
  _CompanySelectionResult({required this.id, required this.name});
}

class CompanySelectionScreen extends StatelessWidget {
  final String? selectedCompanyId;
  const CompanySelectionScreen({super.key, this.selectedCompanyId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is! UsersAuthenticated) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final companies = state.companies;
        return _SelectionScreen<_CompanySelectionResult>(
          title: S.of(context).company,
          items: companies
              .map((c) => _SelectionItem(
                    id: c.id ?? '',
                    name: c.name,
                    code: c.code?.toString() ?? '',
                    email: c.email,
                  ))
              .toList(),
          selectedId: selectedCompanyId,
          onSelect: (item) {
            Navigator.pop(
                context, _CompanySelectionResult(id: item.id, name: item.name));
          },
        );
      },
    );
  }
}

class _BranchSelectionResult {
  final String id;
  final String name;
  _BranchSelectionResult({required this.id, required this.name});
}

class BranchSelectionScreen extends StatelessWidget {
  final String companyId;
  final String? selectedBranchId;
  const BranchSelectionScreen(
      {super.key, required this.companyId, this.selectedBranchId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is! UsersAuthenticated) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final branches =
            state.branches.where((b) => b.company.id == companyId).toList();
        return _SelectionScreen<_BranchSelectionResult>(
          title: S.of(context).branch,
          items: branches
              .map((b) => _SelectionItem(
                    id: b.id ?? '',
                    name: b.name,
                    code: b.code?.toString() ?? '',
                    email: b.email,
                  ))
              .toList(),
          selectedId: selectedBranchId,
          onSelect: (item) {
            Navigator.pop(
                context, _BranchSelectionResult(id: item.id, name: item.name));
          },
        );
      },
    );
  }
}

class _SelectionItem {
  final String id;
  final String name;
  final String code;
  final String email;
  _SelectionItem(
      {required this.id,
      required this.name,
      required this.code,
      required this.email});
}

class _SelectionScreen<T> extends StatefulWidget {
  final String title;
  final List<_SelectionItem> items;
  final void Function(_SelectionItem) onSelect;
  final String? selectedId;
  const _SelectionScreen(
      {required this.title,
      required this.items,
      required this.onSelect,
      this.selectedId});
  @override
  State<_SelectionScreen<T>> createState() => _SelectionScreenState<T>();
}

class _SelectionScreenState<T> extends State<_SelectionScreen<T>> {
  String _search = '';
  @override
  Widget build(BuildContext context) {
    var filtered = widget.items.where((item) {
      final q = _search.toLowerCase();
      return item.name.toLowerCase().contains(q) ||
          item.code.toLowerCase().contains(q) ||
          item.email.toLowerCase().contains(q);
    }).toList();
    // Move selected item to the top if present
    if (widget.selectedId != null) {
      final idx = filtered.indexWhere((item) => item.id == widget.selectedId);
      if (idx > 0) {
        final selectedItem = filtered.removeAt(idx);
        filtered.insert(0, selectedItem);
      }
    }
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Column(
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
            child: filtered.isEmpty
                ? Center(child: Text(S.of(context).noUsersToView))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = widget.selectedId == item.id;
                      return Card(
                        child: ListTile(
                          leading: Text(
                            item.code.toString(),
                            style: CustomStyle.mediumTextBRed,
                          ),
                          title: Text(
                            item.name,
                            style: CustomStyle.mediumTextBRed,
                          ),
                          subtitle: Text(item.email),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () => widget.onSelect(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
