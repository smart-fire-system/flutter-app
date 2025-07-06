import 'dart:async';

import 'package:fire_alarm_system/models/pin.dart';
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
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';

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
    _loadCompaniesAndBranches();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  }

  Future<void> _loadCompaniesAndBranches() async {
    final branchRepo =
        BranchRepository(appRepository: context.read<AppRepository>());
    final authRepo = context.read<AppRepository>().authRepository;
    final data = await branchRepo.getUserBranchesAndCompanies(authRepo);
    setState(() {
      _companies = List<Company>.from(data['companies'] ?? []);
      _branches = List<Branch>.from(data['branches'] ?? []);
    });
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
      setState(() {
        _selectedCompany = _companies.firstWhere((c) => c.id == result.id);
        _selectedBranch = null;
      });
      _onSelectBranch();
    }
  }

  void _onSelectBranch() async {
    if (_selectedCompany == null) return;
    final companyBranches =
        _branches.where((b) => b.company.id == _selectedCompany!.id).toList();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BranchSelectionScreen(
          companyId: _selectedCompany!.id!,
          selectedBranchId: _selectedBranch?.id,
          branches: companyBranches,
        ),
      ),
    );
    if (result is BranchSelectionResult) {
      setState(() {
        _selectedBranch = companyBranches.firstWhere((b) => b.id == result.id);
      });
    } else {
      setState(() {
        _selectedBranch = null;
        _selectedCompany = null;
      });
    }
    _refreshMasters();
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
      context.read<SystemBloc>().add(CancelStreamRequested());
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
    final localTime = dt.toLocal();
    final timeZoneOffset = localTime.timeZoneOffset;
    final offsetHours = timeZoneOffset.inHours;
    final offsetMinutes = timeZoneOffset.inMinutes.remainder(60);
    final gmtSign = offsetHours >= 0 ? '+' : '-';
    final formattedOffset =
        'GMT$gmtSign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';
    final formatter = DateFormat('dd/MM/yyyy - hh:mm:ss a');
    return '${formatter.format(localTime)} $formattedOffset';
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
                              _selectedBranch?.name ?? 'Choose Branch',
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
                            const SizedBox(height: 4),
                            if (_selectedBranch?.code != null)
                              Text(
                                'Branch Code: ${_selectedBranch!.code}',
                                style: CustomStyle.smallText.copyWith(
                                  color: Colors.blueGrey[500],
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
                                  print('refresh');
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
                              onTap: !master.isActive
                                  ? null
                                  : () {
                                      TabNavigator.system.currentState
                                          ?.pushNamed(
                                        '/master/details',
                                        arguments: master.id,
                                      );
                                    },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  leading: Icon(
                                    master.isActive
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: master.isActive
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text('Master ID: ${master.id}'),
                                  subtitle: Text(
                                      'Last Seen: ${formatDateTime(master.lastSeen)}'),
                                  trailing: Text(
                                      master.isActive ? 'Active' : 'Inactive',
                                      style: TextStyle(
                                        color: master.isActive
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      )),
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
