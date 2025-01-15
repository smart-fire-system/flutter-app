import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
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

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  BranchesScreenState createState() => BranchesScreenState();
}

class BranchesScreenState extends State<BranchesScreen> {
  bool _filterRequested = false;
  List<Branch> _branches = [];
  List<Company> _companies = [];
  List<Branch> _filteredBranches = [];
  List<Company> _filteredCompanies = [];
  bool _canAddBranches = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBranches);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBranches() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filterRequested = true;
      _filteredBranches = _branches
          .where((branch) =>
              _filteredCompanies.contains(branch.company) &&
              (branch.name.toLowerCase().contains(query.toLowerCase()) ||
                  branch.code.toString() == query))
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
          _branches = List.from(state.branches);
          _companies = List.from(state.companies);
          _canAddBranches = state.canAddBranches;
          if (_filterRequested) {
            _filterRequested = false;
          } else {
            _filteredBranches = List.from(_branches);
            _filteredCompanies = List.from(_companies);
            _searchController.removeListener(_filterBranches);
            _searchController.clear();
            _searchController.addListener(_filterBranches);
          }
          return _buildBranches(context);
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

  Widget _buildBranches(BuildContext context) {
    AppLoading().dismiss(context: context, screen: AppScreen.viewBranches);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).branches),
      floatingActionButton: !_canAddBranches
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () {
                TabNavigator.settings.currentState?.popAndPushNamed(
                    '/branches/add');
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
          !_canAddBranches ? null : FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BranchesBloc>().add(AuthChanged());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomDropdownMulti(
                title: S.of(context).companies,
                subtitle: S.of(context).selectCompanies,
                allSelectedText: S.of(context).allCompanies,
                noSelectedText: S.of(context).noCompaniesSelected,
                items: _companies.map((company) {
                  return CustomDropdownItem(
                      title: company.name, value: company.id);
                }).toList(),
                icon: Icons.filter_alt,
                onChanged: (filteredItems) {
                  setState(() {
                    final filteredIds =
                        filteredItems.map((item) => item.value).toSet();
                    _filteredCompanies = _companies
                        .where((company) => filteredIds.contains(company.id))
                        .toList();
                    _filterBranches();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
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
              _filteredBranches.isEmpty
                  ? Text(
                      S.of(context).noBranchesToView,
                      style: CustomStyle.mediumTextB,
                    )
                  : Flexible(
                      child: ListView(
                        children:
                            _filteredBranches.asMap().entries.map((entry) {
                          var branch = entry.value;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(branch.company.logoURL),
                              radius: 25.0,
                            ),
                            title: Text(
                              branch.name,
                              style: CustomStyle.mediumTextB,
                            ),
                            subtitle: Text(
                              branch.company.name,
                              style: CustomStyle.smallText,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              TabNavigator.settings.currentState?.pushNamed(
                                  '/branches/details',
                                  arguments: branch.id);
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
      floatingActionButton: !_canAddBranches
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              label: Text(S.of(context).addBranch,
                  style: CustomStyle.mediumTextWhite),
            ),
      floatingActionButtonLocation:
          !_canAddBranches ? null : FloatingActionButtonLocation.endFloat,
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
