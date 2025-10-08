import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
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

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  CompaniesScreenState createState() => CompaniesScreenState();
}

class CompaniesScreenState extends State<CompaniesScreen> {
  bool _filterRequested = false;
  List<Company> _companies = [];
  List<Company> _filteredCompanies = [];
  AppPermissions _permissions = AppPermissions();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCompanies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCompanies() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filterRequested = true;
      _filteredCompanies = _companies
          .where((company) =>
              (company.name.toLowerCase().contains(query.toLowerCase()) ||
                  company.code.toString() == query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state is BranchesAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(
                context: context,
                title: Errors.getFirebaseErrorMessage(context, state.error!),
              );
              state.error = null;
            }
          });
          _permissions = state.user.permissions as AppPermissions;
          _companies = List.from(state.companies);
          if (_filterRequested) {
            _filterRequested = false;
          } else {
            _filteredCompanies = List.from(_companies);
            _searchController.removeListener(_filterCompanies);
            _searchController.clear();
            _searchController.addListener(_filterCompanies);
          }
          return _buildCompanies(context);
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

  Widget _buildCompanies(BuildContext context) {
    AppLoading().dismiss(context: context, screen: AppScreen.viewCompanies);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).companies),
      floatingActionButton: !_permissions.canAddCompanies
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () {
                TabNavigator.usersAndBranches.currentState
                    ?.pushNamed('/company/add');
              },
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              label: Text(S.of(context).addCompany,
                  style: CustomStyle.mediumTextWhite),
            ),
      floatingActionButtonLocation: !_permissions.canAddCompanies
          ? null
          : FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BranchesBloc>().add(Refresh());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: S.of(context).searchByNameCode,
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
              _filteredCompanies.isEmpty
                  ? Text(
                      S.of(context).noCompaniesToView,
                      style: CustomStyle.mediumTextB,
                    )
                  : Flexible(
                      child: ListView(
                        children:
                            _filteredCompanies.asMap().entries.map((entry) {
                          var company = entry.value;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(company.logoURL),
                              radius: 25.0,
                            ),
                            title: Text(
                              company.name,
                              style: CustomStyle.mediumTextB,
                            ),
                            subtitle: company.comment.isEmpty
                                ? null
                                : Text(
                                    company.comment,
                                    style: CustomStyle.smallText,
                                  ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              TabNavigator.usersAndBranches.currentState
                                  ?.pushNamed('/company/details',
                                      arguments: company.id);
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
      AppLoading().show(context: context, screen: AppScreen.viewCompanies);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).companies),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                itemCount: 5,
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
