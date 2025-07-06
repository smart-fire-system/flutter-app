import 'dart:async';

import 'package:fire_alarm_system/models/pin.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
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
  List<Master> _masters = [];
  late Timer _timer;

  // Add state for company/branch selection and loading
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
      _refreshMasters();
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
        }
        return _buildSystem(context);
      },
    );
  }

  void handleLastSeen() {
    final now = DateTime.now();
    for (Master master in _masters) {
      final lastUpdate = master.lastSeen;
      final difference = now.difference(lastUpdate);
      if (difference.inSeconds <= 10 && !master.isActive) {
        setState(() {
          master.isActive = true;
        });
      } else if (difference.inSeconds > 10 && master.isActive) {
        setState(() {
          master.isActive = false;
        });
      }
    }
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
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _onSelectCompany,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedCompany?.name ?? 'Choose Company',
                        style: CustomStyle.mediumText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _selectedCompany != null ? _onSelectBranch : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color:
                            _selectedCompany == null ? Colors.grey[200] : null,
                      ),
                      child: Text(
                        _selectedBranch?.name ?? 'Choose Branch',
                        style: CustomStyle.mediumText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CustomNormalButton(
                  label: 'Refresh',
                  icon: Icons.refresh,
                  onPressed: _selectedBranch != null ? _refreshMasters : null,
                ),
              ],
            ),
          ),
          Expanded(
            child: _masters.isEmpty
                ? const Center(child: Text('No masters found'))
                : ListView.builder(
                    itemCount: _masters.length,
                    itemBuilder: (context, index) {
                      final master = _masters[index];
                      return GestureDetector(
                        onTap: !master.isActive ? null : () {
                          TabNavigator.system.currentState?.pushNamed(
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
                              color:
                                  master.isActive ? Colors.green : Colors.red,
                            ),
                            title: Text('Master ID: ${master.id}'),
                            subtitle: Text(
                                'Last Seen: ${formatDateTime(master.lastSeen)}'),
                            trailing:
                                Text(master.isActive ? 'Active' : 'Inactive',
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
        ],
      ),
    );
  }
}
