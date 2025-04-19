import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:fire_alarm_system/widgets/dropdown.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:fire_alarm_system/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  bool _isFirstFilterCall = true;
  dynamic _roleUser;
  List<Company> _companies = [];
  List<Branch> _branches = [];
  List<CustomDropdownItem> _userTypesDropdown = [];
  List<CustomDropdownItem> _filteredUserTypesDropdown = [];
  AppPermissions _permissions = AppPermissions();
  final Users _users = Users();
  final Users _filteredUsers = Users();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(
                context: context,
                title: Errors.getFirebaseErrorMessage(context, state.error!),
              );
              state.error = null;
            }
          });
          _roleUser = state.roleUser;
          _companies = state.companies;
          _branches = state.branches;
          _permissions = state.roleUser.permissions as AppPermissions;
          _users.masterAdmins = List.from(state.masterAdmins);
          _users.admins = List.from(state.admins);
          _users.companyManagers = List.from(state.companyManagers);
          _users.branchManagers = List.from(state.branchManagers);
          _users.employees = List.from(state.employees);
          _users.clients = List.from(state.clients);
          _users.noRoleUsers = List.from(state.noRoleUsers);
          _userTypesDropdown = [];
          if (_roleUser is MasterAdmin) {
            _userTypesDropdown.add(
              CustomDropdownItem(
                title: S.of(context).masterAdmins,
                value: 'masterAdmins',
              ),
            );
          }
          if (_permissions.canViewAdmins) {
            _userTypesDropdown.add(
              CustomDropdownItem(
                title: S.of(context).admins,
                value: 'admins',
              ),
            );
          }
          if (_permissions.canViewCompanyManagers) {
            _userTypesDropdown.add(
              CustomDropdownItem(
                title: S.of(context).companyManagers,
                value: 'companyManagers',
              ),
            );
          }
          if (_permissions.canViewBranchManagers) {
            _userTypesDropdown.add(
              CustomDropdownItem(
                title: S.of(context).branchManagers,
                value: 'branchManagers',
              ),
            );
          }
          if (_permissions.canViewEmployees) {
            _userTypesDropdown.add(
              CustomDropdownItem(
                title: S.of(context).employees,
                value: 'employees',
              ),
            );
          }
          if (_permissions.canViewClients) {
            _userTypesDropdown.add(
              CustomDropdownItem(
                title: S.of(context).clients,
                value: 'clients',
              ),
            );
          }
          if (_permissions.canUpdateAdmins ||
              _permissions.canUpdateCompanyManagers ||
              _permissions.canUpdateBranchManagers ||
              _permissions.canUpdateEmployees ||
              _permissions.canUpdateClients) {
            _userTypesDropdown.add(
              CustomDropdownItem(
                  title: S.of(context).noRoleUsers, value: 'noRoleUsers'),
            );
          }
          return _buildUsers(context);
        } else if (state is BranchesNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          });
        }
        return _buildLoading(context);
      },
    );
  }

  Widget _buildUsers(BuildContext context) {
    AppLoading().dismiss(context: context, screen: AppScreen.viewUsers);
    _filterUsers();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).users),
      floatingActionButton: !(_roleUser is MasterAdmin ||
              _permissions.canUpdateAdmins ||
              _permissions.canUpdateCompanyManagers ||
              _permissions.canUpdateBranchManagers ||
              _permissions.canUpdateEmployees ||
              _permissions.canUpdateClients)
          ? null
          : ExpandableFab(
              type: ExpandableFabType.up,
              childrenAnimation: ExpandableFabAnimation.none,
              distance: 70,
              overlayStyle: ExpandableFabOverlayStyle(
                color: Colors.white.withValues(alpha: 0.6),
              ),
              closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                child: const Icon(Icons.close),
                fabSize: ExpandableFabSize.small,
                foregroundColor: Colors.white,
                backgroundColor: CustomStyle.redDark,
                shape: const CircleBorder(),
              ),
              openButtonBuilder: RotateFloatingActionButtonBuilder(
                child: const Icon(Icons.add),
                fabSize: ExpandableFabSize.regular,
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: const CircleBorder(),
              ),
              children: [
                if (_roleUser is MasterAdmin)
                  CustomBasicButton(
                    label: S.of(context).addNewMasterAdmin,
                    onPressed: () {
                      TabNavigator.settings.currentState
                          ?.pushNamed('/masterAdmin/add');
                    },
                  ),
                if (_permissions.canUpdateAdmins)
                  CustomBasicButton(
                    label: S.of(context).addNewAdmin,
                    onPressed: () {
                      TabNavigator.settings.currentState
                          ?.pushNamed('/admin/add');
                    },
                  ),
                if (_permissions.canUpdateCompanyManagers)
                  CustomBasicButton(
                    label: S.of(context).addNewCompanyManager,
                    onPressed: () {
                      if (_companies.isEmpty) {
                        CustomAlert.showError(
                          context: context,
                          title: S.of(context).noCompaneiesToAddCompanyManager,
                        );
                      } else {
                        TabNavigator.settings.currentState
                            ?.pushNamed('/companyManager/add');
                      }
                    },
                  ),
                if (_permissions.canUpdateBranchManagers)
                  CustomBasicButton(
                    label: S.of(context).addNewBranchManager,
                    onPressed: () {
                      if (_branches.isEmpty) {
                        CustomAlert.showError(
                          context: context,
                          title: S.of(context).noBranchesToAddBranchManager,
                        );
                      } else {
                        TabNavigator.settings.currentState
                            ?.pushNamed('/branchManager/add');
                      }
                    },
                  ),
                if (_permissions.canUpdateEmployees)
                  CustomBasicButton(
                    label: S.of(context).addNewEmployee,
                    onPressed: () {
                      if (_branches.isEmpty) {
                        CustomAlert.showError(
                          context: context,
                          title: S.of(context).noBranchesToAddEmployee,
                        );
                      } else {
                        TabNavigator.settings.currentState
                            ?.pushNamed('/employee/add');
                      }
                    },
                  ),
                if (_permissions.canUpdateClients)
                  CustomBasicButton(
                    label: S.of(context).addNewClient,
                    onPressed: () {
                      if (_branches.isEmpty) {
                        CustomAlert.showError(
                          context: context,
                          title: S.of(context).noBranchesToAddClient,
                        );
                      } else {
                        TabNavigator.settings.currentState
                            ?.pushNamed('/client/add');
                      }
                    },
                  ),
              ],
            ),
      floatingActionButtonLocation: ExpandableFab.location,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BranchesBloc>().add(AuthChanged());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomDropdownMulti(
                title: S.of(context).users,
                subtitle: S.of(context).selectUsers,
                allSelectedText: S.of(context).allUsers,
                noSelectedText: S.of(context).noUsersSelected,
                items: _userTypesDropdown,
                icon: Icons.filter_alt,
                onChanged: (filteredItems) {
                  setState(() {
                    _filteredUserTypesDropdown = List.from(filteredItems);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: S.of(context).searchBy,
                    labelStyle: CustomStyle.smallTextGrey,
                    border: const OutlineInputBorder(),
                    prefixIcon:
                        const Icon(Icons.search, color: CustomStyle.redDark),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomStyle.redDark,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              _filteredUsers.masterAdmins.isEmpty &&
                      _filteredUsers.admins.isEmpty &&
                      _filteredUsers.companyManagers.isEmpty &&
                      _filteredUsers.branchManagers.isEmpty &&
                      _filteredUsers.employees.isEmpty &&
                      _filteredUsers.clients.isEmpty &&
                      _filteredUsers.noRoleUsers.isEmpty
                  ? Text(
                      S.of(context).noUsersToView,
                      style: CustomStyle.mediumTextB,
                    )
                  : Container(),
              Flexible(
                child: ListView(
                  children: [
                    ..._filteredUsers.masterAdmins.asMap().entries.map(
                      (entry) {
                        var user = entry.value;
                        return CustomUserCard(
                          index: entry.key + 1,
                          code: user.info.code,
                          name: user.info.name,
                          role: S.of(context).masterAdmin,
                          onTap: () {
                            TabNavigator.settings.currentState?.pushNamed(
                              '/user/details',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                    ..._filteredUsers.admins.asMap().entries.map(
                      (entry) {
                        var user = entry.value;
                        return CustomUserCard(
                          index: entry.key +
                              1 +
                              _filteredUsers.masterAdmins.length,
                          code: user.info.code,
                          name: user.info.name,
                          role: S.of(context).admin,
                          onTap: () {
                            TabNavigator.settings.currentState?.pushNamed(
                              '/user/details',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                    ..._filteredUsers.companyManagers.asMap().entries.map(
                      (entry) {
                        var user = entry.value;
                        return CustomUserCard(
                          index: entry.key +
                              1 +
                              _filteredUsers.masterAdmins.length +
                              _filteredUsers.admins.length,
                          code: user.info.code,
                          name: user.info.name,
                          role: S.of(context).companyManager,
                          companyName: user.company.name,
                          onTap: () {
                            TabNavigator.settings.currentState?.pushNamed(
                              '/user/details',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                    ..._filteredUsers.branchManagers.asMap().entries.map(
                      (entry) {
                        var user = entry.value;
                        return CustomUserCard(
                          index: entry.key +
                              1 +
                              _filteredUsers.masterAdmins.length +
                              _filteredUsers.admins.length +
                              _filteredUsers.companyManagers.length,
                          code: user.info.code,
                          name: user.info.name,
                          role: S.of(context).branchManager,
                          companyName: user.branch.company.name,
                          branchName: user.branch.name,
                          onTap: () {
                            TabNavigator.settings.currentState?.pushNamed(
                              '/user/details',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                    ..._filteredUsers.employees.asMap().entries.map(
                      (entry) {
                        var user = entry.value;
                        return CustomUserCard(
                          index: entry.key +
                              1 +
                              _filteredUsers.masterAdmins.length +
                              _filteredUsers.admins.length +
                              _filteredUsers.companyManagers.length +
                              _filteredUsers.branchManagers.length,
                          code: user.info.code,
                          name: user.info.name,
                          role: S.of(context).employee,
                          companyName: user.branch.company.name,
                          branchName: user.branch.name,
                          onTap: () {
                            TabNavigator.settings.currentState?.pushNamed(
                              '/user/details',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                    ..._filteredUsers.clients.asMap().entries.map(
                      (entry) {
                        var user = entry.value;
                        return CustomUserCard(
                          index: entry.key +
                              1 +
                              _filteredUsers.masterAdmins.length +
                              _filteredUsers.admins.length +
                              _filteredUsers.companyManagers.length +
                              _filteredUsers.branchManagers.length +
                              _filteredUsers.employees.length,
                          code: user.info.code,
                          name: user.info.name,
                          role: S.of(context).client,
                          companyName: user.branch.company.name,
                          branchName: user.branch.name,
                          onTap: () {
                            TabNavigator.settings.currentState?.pushNamed(
                              '/user/details',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                    ..._filteredUsers.noRoleUsers.asMap().entries.map(
                      (entry) {
                        var user = entry.value;
                        return CustomUserCard(
                          index: entry.key +
                              1 +
                              _filteredUsers.masterAdmins.length +
                              _filteredUsers.admins.length +
                              _filteredUsers.companyManagers.length +
                              _filteredUsers.branchManagers.length +
                              _filteredUsers.employees.length +
                              _filteredUsers.clients.length,
                          code: user.info.code,
                          name: user.info.name,
                          role: S.of(context).noRole,
                          onTap: () {
                            TabNavigator.settings.currentState?.pushNamed(
                              '/user/details',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      AppLoading().show(context: context, screen: AppScreen.viewUsers);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).branches),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomDropdownMulti(
              title: S.of(context).companies,
              subtitle: S.of(context).selectCompanies,
              allSelectedText: S.of(context).allCompanies,
              noSelectedText: S.of(context).noCompaniesSelected,
              items: const [],
              icon: Icons.filter_alt,
              onChanged: (_) {},
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: S.of(context).searchByNameCode,
                  labelStyle: CustomStyle.smallTextGrey,
                  border: const OutlineInputBorder(),
                  prefixIcon:
                      const Icon(Icons.search, color: CustomStyle.redDark),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Simulate loading for 5 items
                itemBuilder: (context, index) => const CardLoading(
                  height: 80,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  margin: EdgeInsets.only(bottom: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    if (_isFirstFilterCall) {
      _isFirstFilterCall = false;
      _filteredUserTypesDropdown = List.from(_userTypesDropdown);
    }
    if (_filteredUserTypesDropdown
        .any((item) => item.value == 'masterAdmins')) {
      _filteredUsers.masterAdmins = _users.masterAdmins
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.masterAdmins = [];
    }
    if (_filteredUserTypesDropdown.any((item) => item.value == 'admins')) {
      _filteredUsers.admins = _users.admins
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.admins = [];
    }
    if (_filteredUserTypesDropdown
        .any((item) => item.value == 'companyManagers')) {
      _filteredUsers.companyManagers = _users.companyManagers
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.companyManagers = [];
    }
    if (_filteredUserTypesDropdown
        .any((item) => item.value == 'branchManagers')) {
      _filteredUsers.branchManagers = _users.branchManagers
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.branchManagers = [];
    }
    if (_filteredUserTypesDropdown.any((item) => item.value == 'employees')) {
      _filteredUsers.employees = _users.employees
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.employees = [];
    }
    if (_filteredUserTypesDropdown.any((item) => item.value == 'clients')) {
      _filteredUsers.clients = _users.clients
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.clients = [];
    }
    if (_filteredUserTypesDropdown.any((item) => item.value == 'noRoleUsers')) {
      _filteredUsers.noRoleUsers = _users.noRoleUsers
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.noRoleUsers = [];
    }
  }
}
