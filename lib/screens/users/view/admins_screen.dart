import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/dropdown.dart';
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

enum UsersScreenView {
  admins,
  companyManagers,
  branchManagers,
  employees,
  clients,
  noRoleUsers
}

class UsersScreen extends StatefulWidget {
  final UsersScreenView view;
  const UsersScreen({super.key, required this.view});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  bool _filterRequested = false;
  dynamic _roleUser;
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  List<Company> _companies = [];
  List<Branch> _branches = [];
  final TextEditingController _searchController = TextEditingController();

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
    setState(() {
      _filterRequested = true;
      _filteredUsers = _users
          .where((user) =>
              user.info.name.toLowerCase().contains(query.toLowerCase()) ||
              user.info.phoneNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.info.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
          if (widget.view == UsersScreenView.admins) {
            _users = List.from(state.admins);
          } else if (widget.view == UsersScreenView.companyManagers) {
            _users = List.from(state.companyManagers);
          } else if (widget.view == UsersScreenView.branchManagers) {
            _users = List.from(state.branchManagers);
          } else if (widget.view == UsersScreenView.employees) {
            _users = List.from(state.employees);
          } else if (widget.view == UsersScreenView.clients) {
            _users = List.from(state.clients);
          } else if (widget.view == UsersScreenView.noRoleUsers) {
            _users = List.from(state.noRoleUsers);
          }
          if (_filterRequested) {
            _filterRequested = false;
          } else {
            _filteredUsers = List.from(_users);
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
    AppLoading().dismiss(context: context, screen: AppScreen.viewBranches);
    bool canAdd = false;
    String role = 'noRoleUsers';
    if (widget.view == UsersScreenView.admins) {
      canAdd = _roleUser.permissions.canAddAdmins;
      role = 'admin';
    } else if (widget.view == UsersScreenView.companyManagers) {
      canAdd = _roleUser.permissions.canAddCompanyManagers;
      role = 'companyManager';
    } else if (widget.view == UsersScreenView.branchManagers) {
      canAdd = _roleUser.permissions.canAddBranchManagers;
      role = 'branchManager';
    } else if (widget.view == UsersScreenView.employees) {
      canAdd = _roleUser.permissions.canAddEmployees;
      role = 'employee';
    } else if (widget.view == UsersScreenView.clients) {
      canAdd = _roleUser.permissions.canAddClients;
      role = 'client';
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).branches),
      floatingActionButton: !canAdd
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () {
                String? errorMessage;
                if (_branches.isEmpty) {
                  if (widget.view == UsersScreenView.branchManagers) {
                    errorMessage = 'No branches to add manager';
                  } else if (widget.view == UsersScreenView.employees) {
                    errorMessage = 'No branches to add employee';
                  } else if (widget.view == UsersScreenView.clients) {
                    errorMessage = 'No branches to add client';
                  } else if (widget.view == UsersScreenView.companyManagers) {
                    errorMessage = _companies.isEmpty
                        ? 'No companies to add manager'
                        : null;
                  }
                }
                if (errorMessage == null) {
                  TabNavigator.settings.currentState?.pushNamed('/$role/add');
                } else {
                  CustomAlert.showError(
                    context: context,
                    title: errorMessage,
                  );
                }
              },
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              label: Text(S.of(context).addBranch,
                  style: CustomStyle.mediumTextWhite),
            ),
      floatingActionButtonLocation:
          !canAdd ? null : FloatingActionButtonLocation.endFloat,
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
              _filteredUsers.isEmpty
                  ? Text(
                      S.of(context).noBranchesToView,
                      style: CustomStyle.mediumTextB,
                    )
                  : Flexible(
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
                                '/$role/details',
                                arguments: user.info.id,
                              );
                            },
                          );
                        }).toList(),
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
      AppLoading().show(context: context, screen: AppScreen.viewBranches);
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
