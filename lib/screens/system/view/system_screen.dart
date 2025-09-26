import 'dart:async';

import 'package:fire_alarm_system/models/pin.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/screens/system/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/system/bloc/event.dart';
import 'package:fire_alarm_system/screens/system/bloc/state.dart';
import 'package:intl/intl.dart';
import 'package:fire_alarm_system/widgets/selection_screen.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/branch.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});
  @override
  SystemScreenState createState() => SystemScreenState();
}

class SystemScreenState extends State<SystemScreen> {
  List<Master>? _masters;
  late Timer _timer;

  Company? _selectedCompany;
  Branch? _selectedBranch;
  List<Company> _companies = [];
  List<Branch> _branches = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  }

  void _onSelectCompany() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompanySelectionScreen(
          selectedCompanyId: _selectedCompany?.id,
          companies: _companies,
        ),
      ),
    );
    if (result is CompanySelectionResult) {
      _onSelectBranch(_companies.firstWhere((c) => c.id == result.id));
    }
  }

  void _onSelectBranch(Company company) async {
    final companyBranches =
        _branches.where((b) => b.company.id == company.id).toList();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BranchSelectionScreen(
          companyId: company.id!,
          selectedBranchId: _selectedBranch?.id,
          branches: companyBranches,
        ),
      ),
    );
    if (result is BranchSelectionResult) {
      setState(() {
        _selectedBranch = companyBranches.firstWhere((b) => b.id == result.id);
        _selectedCompany = company;
        _refreshMasters();
      });
    }
  }

  void _refreshMasters() {
    if (_selectedBranch?.code != null) {
      context
          .read<SystemBloc>()
          .add(RefreshRequested(branchCode: _selectedBranch!.code!));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context.read<SystemBloc>().add(CancelStreamRequested());
      }
    });
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, state) {
        if (state is SystemNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (Route<dynamic> route) => false,
            );
          });
        } else if (state is SystemAuthenticated) {
          _masters = state.masters ?? [];
          _companies = state.companies;
          _branches = state.branches;
          if (state.branchesChanged) {
            _selectedBranch = null;
            _selectedCompany = null;
            _masters = [];
          }
        } else if (state is SystemLoading) {
          _masters = null;
        }
        return _buildSystem(context);
      },
    );
  }

  String formatDateTime(DateTime dt) {
    return DateFormat('dd/MM/yyyy - hh:mm:ss a').format(dt.toLocal());
  }

  Widget _buildSystem(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).system),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                _onSelectCompany();
              },
              child: Card(
                elevation: 4,
                color: Colors.blueGrey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.business,
                            color: CustomStyle.redDark, size: 32),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedBranch == null
                                  ? 'Choose Branch'
                                  : '${_selectedBranch!.name} - [${S.of(context).code}: ${_selectedBranch!.code}]',
                              style: CustomStyle.mediumText.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedCompany?.name ??
                                  'Tap to select branch for viewing the data',
                              style: CustomStyle.smallText.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.chevron_right,
                          color: Colors.blueGrey, size: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _masters == null
                ? const Center(child: CircularProgressIndicator())
                : _masters!.isEmpty
                    ? Center(
                        child: _selectedBranch == null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _onSelectCompany();
                                    },
                                    child: Image.asset(
                                      'assets/images/choose.png',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Please select a branch to view the data',
                                    style: CustomStyle.mediumTextBRed,
                                  ),
                                ],
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  _refreshMasters();
                                },
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/empty.png',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No masters found for this branch.',
                                          style: CustomStyle.mediumTextBRed,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _refreshMasters();
                        },
                        child: ListView.builder(
                          itemCount: _masters!.length,
                          itemBuilder: (context, index) {
                            final master = _masters![index];
                            return GestureDetector(
                              onTap: () async {
                                if (master.isActive) {
                                  TabNavigator.system.currentState?.pushNamed(
                                    '/master/details',
                                    arguments: master.id,
                                  );
                                } else {
                                  final value = await CustomAlert.showConfirmation(
                                      context: context,
                                      title: 'Delete Master',
                                      subtitle:
                                          'Are you sure you want to delete this master?',
                                      buttons: [
                                        CustomAlertConfirmationButton(
                                          title: 'Yes, delete it',
                                          value: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                        ),
                                        CustomAlertConfirmationButton(
                                          title: 'No, cancel',
                                          value: 0,
                                          backgroundColor:
                                              CustomStyle.greyMedium,
                                          textColor: Colors.white,
                                        ),
                                      ]);
                                  if (value == 1 && context.mounted) {
                                    context.read<SystemBloc>().add(
                                          MasterDeleteRequested(
                                            branchCode: _selectedBranch!.code!,
                                            masterId: master.id,
                                          ),
                                        );
                                  }
                                }
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                color: master.isActive
                                    ? Colors.green[100]
                                    : Colors.red[100],
                                child: ListTile(
                                  leading: Icon(
                                    master.isActive
                                        ? Icons.cloud_done
                                        : Icons.cloud_off,
                                    color: master.isActive
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text('Master ID: ${master.id}'),
                                  subtitle: Text(
                                      'Last Seen: ${formatDateTime(master.lastSeen)}'),
                                  trailing: master.isActive
                                      ? const Icon(Icons.arrow_forward_sharp,
                                          color: Colors.green, size: 32)
                                      : const Icon(Icons.delete,
                                          color: Colors.red, size: 32),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
