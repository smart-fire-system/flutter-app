import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
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
  User? _user;
  List<Branch> _branches = [];
  List<Company> _companies = [];
  List<Branch> _filteredBranches = [];
  List<Company> _filteredCompanies = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _companiesFilterController =
      TextEditingController();

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
                  branch.comment.toLowerCase().contains(query.toLowerCase()) ||
                  branch.company.name
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
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
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
              state.error = null;
            } else if (state.message != null) {
              if (state.message == BranchesMessage.branchModified) {
                CustomAlert.showSuccess(context, S.of(context).branchModified);
                state.message = null;
              } else if (state.message == BranchesMessage.branchAdded) {
                CustomAlert.showSuccess(context, S.of(context).branchAdded);
                state.message = null;
              } else if (state.message == BranchesMessage.branchDeleted) {
                CustomAlert.showSuccess(context, S.of(context).branchDeleted);
                state.message = null;
              }
            }
          });
          _user = state.user;
          _branches = state.branches;
          _companies = state.companies;
          if (_filterRequested) {
            _filterRequested = false;
          } else {
            _filteredBranches = List.from(_branches);
            _filteredCompanies = List.from(_companies);
            _companiesFilterController.text = "All Companies";
            _searchController.removeListener(_filterBranches);
            _searchController.clear();
            _searchController.addListener(_filterBranches);
          }
          return _buildBranches(context);
        } else if (state is BranchesNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (Route<dynamic> route) => false,
            );
          });
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildBranches(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).branches),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {},
        icon: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        label: Text("Add", style: CustomStyle.mediumTextWhite),
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
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                child: Center(
                  child: TextField(
                    controller: _companiesFilterController,
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Please choose a company',
                                          style: CustomStyle.mediumTextB,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.keyboard_return,
                                            color: CustomStyle.redDark,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  CheckboxListTile(
                                    title: const Text("All Companies"),
                                    tristate: true,
                                    activeColor: (_filteredCompanies.length ==
                                            _companies.length)
                                        ? CustomStyle.redDark
                                        : CustomStyle.greyDark,
                                    value: (_filteredCompanies.length ==
                                            _companies.length)
                                        ? true
                                        : _filteredCompanies.isEmpty
                                            ? false
                                            : null,
                                    onChanged: (bool? value) {
                                      if (_filteredCompanies.length ==
                                          _companies.length) {
                                        _filteredCompanies = [];
                                        _companiesFilterController.text =
                                            "No Selected Company";
                                      } else {
                                        _filteredCompanies =
                                            List.from(_companies);
                                        _companiesFilterController.text =
                                            "All Companies";
                                      }
                                      setState(() {
                                        _filterBranches();
                                      });
                                    },
                                  ),
                                  const Divider(height: 1.0),
                                  Expanded(
                                    child: ListView(
                                      children: _companies
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        var company = entry.value;
                                        return CheckboxListTile(
                                          title: Text(company.name),
                                          subtitle: Text(company.comment),
                                          activeColor: CustomStyle.redDark,
                                          value: _filteredCompanies
                                              .contains(company),
                                          onChanged: (bool? value) {
                                            if (_filteredCompanies
                                                .contains(company)) {
                                              _filteredCompanies
                                                  .remove(company);
                                              if (_filteredCompanies.isEmpty) {
                                                _companiesFilterController
                                                        .text =
                                                    "No Selected Company";
                                              } else {
                                                _companiesFilterController
                                                        .text =
                                                    _filteredCompanies
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                  var company = entry.value;
                                                  return company.name;
                                                }).join(", ");
                                              }
                                            } else {
                                              _filteredCompanies.add(company);
                                              if (_filteredCompanies.length ==
                                                  _companies.length) {
                                                _companiesFilterController
                                                    .text = "All Companies";
                                              } else {
                                                _companiesFilterController
                                                        .text =
                                                    _filteredCompanies
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                  var company = entry.value;
                                                  return company.name;
                                                }).join(", ");
                                              }
                                            }
                                            setState(() {
                                              _filterBranches();
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                      );
                    },
                    decoration: InputDecoration(
                      labelText: 'Company',
                      labelStyle: CustomStyle.smallTextGrey,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.filter_alt,
                          color: CustomStyle.redDark),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomStyle.redDark,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
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
              Flexible(
                child: ListView(
                  children: _filteredBranches.asMap().entries.map((entry) {
                    var branch = entry.value;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(branch.company.logoURL),
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
                        TabNavigator.settings.currentState
                            ?.pushNamed('/branches/details', arguments: branch);
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
}
