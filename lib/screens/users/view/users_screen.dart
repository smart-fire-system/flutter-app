import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:fire_alarm_system/widgets/dropdown.dart';
import 'package:fire_alarm_system/widgets/expandable_fab.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  bool _filterRequested = false;
  dynamic _roleUser;
  Users _users = Users();
  Users _filteredUsers = Users();
  List<Company> _companies = [];
  List<Branch> _branches = [];
  final TextEditingController _searchController = TextEditingController();
  bool _canAddMasterAdmins = false;
  bool _canAddAdmins = false;
  bool _canAddCompanyManagers = false;
  bool _canAddBranchManagers = false;
  bool _canAddEmployees = false;
  bool _canAddClients = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    /*setState(() {
      _filterRequested = true;
      _filteredUsers = _users
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });*/
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
          _users.masterAdmins = List.from(state.masterAdmins);
          _users.admins = List.from(state.admins);
          _users.companyManagers = List.from(state.companyManagers);
          _users.branchManagers = List.from(state.branchManagers);
          _users.employees = List.from(state.employees);
          _users.clients = List.from(state.clients);
          _users.noRoleUsers = List.from(state.noRoleUsers);
          _canAddMasterAdmins = _roleUser is MasterAdmin;
          print(_canAddMasterAdmins);
          _canAddAdmins = _roleUser.permissions.canUpdateAdmins;
          _canAddCompanyManagers =
              _roleUser.permissions.canUpdateCompanyManagers;
          _canAddBranchManagers = _roleUser.permissions.canUpdateBranchManagers;
          _canAddEmployees = _roleUser.permissions.canUpdateEmployees;
          _canAddClients = _roleUser.permissions.canUpdateClients;

          if (_filterRequested) {
            _filterRequested = false;
          } else {
            _filteredUsers.masterAdmins = List.from(_users.masterAdmins);
            _filteredUsers.admins = List.from(_users.admins);
            _filteredUsers.companyManagers = List.from(_users.companyManagers);
            _filteredUsers.branchManagers = List.from(_users.branchManagers);
            _filteredUsers.employees = List.from(_users.employees);
            _filteredUsers.clients = List.from(_users.clients);
            _filteredUsers.noRoleUsers = List.from(_users.noRoleUsers);
            _searchController.removeListener(_filterUsers);
            _searchController.clear();
            _searchController.addListener(_filterUsers);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).users),
      floatingActionButton: !(_canAddMasterAdmins ||
              _canAddAdmins ||
              _canAddCompanyManagers ||
              _canAddBranchManagers ||
              _canAddEmployees ||
              _canAddClients)
          ? null
          : ExpandableFab(
              title: S.of(context).add,
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
              distance: 45,
              children: [
                CustomNormalButton(
                  label: 'Hello 1',
                  onPressed: () {
                    print("Hello 1");
                  },
                ),
                CustomNormalButton(
                  label: 'Hello 2',
                  onPressed: () {
                    print("Hello 2");
                  },
                ),
                CustomNormalButton(
                  label: 'Hello 3',
                  onPressed: () {
                    print("Hello 3");
                  },
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BranchesBloc>().add(AuthChanged());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                  : Container(),/*Flexible(
                      child: ListView(
                        children: _filteredUsers.asMap().entries.map((entry) {
                          var user = entry.value;
                          String subtitle = '';
                          if (user is CompanyManager) {
                            subtitle = user.company.name;
                          } else if (user is BranchManager) {
                            subtitle = user.branch.name;
                          } else if (user is Employee) {
                            subtitle = user.branch.name;
                          } else if (user is Client) {
                            subtitle = user.branch.name;
                          } else {
                            subtitle = user.info.email;
                          }
                          return ListTile(
                            leading: Text(
                              (entry.key + 1).toString(),
                              style: CustomStyle.mediumTextBRed,
                            ),
                            title: Text(
                              user.info.name,
                              style: CustomStyle.mediumTextB,
                            ),
                            subtitle: Text(
                              subtitle,
                              style: CustomStyle.smallText,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              TabNavigator.settings.currentState?.pushNamed(
                                '/user/details',
                                arguments: user,
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),*/
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
}
