import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/emergency_visit.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/emergency_visit_summary.dart';
import 'package:fire_alarm_system/screens/reports/view/emergency_visit_details_screen.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmergencyVisitsScreen extends StatefulWidget {
  final String contractId;
  const EmergencyVisitsScreen({super.key, required this.contractId});

  @override
  State<EmergencyVisitsScreen> createState() => _EmergencyVisitsScreenState();
}

enum _EmergencyVisitStatusFilterOption {
  all,
  pending,
  approved,
  rejected,
  completed,
  cancelled,
}

class _EmergencyVisitsScreenState extends State<EmergencyVisitsScreen> {
  bool _sortOldToNew = true;
  bool _canRequestEmergencyVisit = false;
  EmergencyVisitStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.emergency_visits),
      floatingActionButton: _canRequestEmergencyVisit
          ? FloatingActionButton.extended(
              label: Text(
                l10n.emergency_visit_request,
                style: CustomStyle.mediumTextWhite,
              ),
              backgroundColor: Colors.red,
              icon: const Icon(Icons.add, size: 30, color: Colors.white),
              onPressed: () => _openRequestBottomSheet(context),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsAuthenticated) {
            if (state.message != null) {
              switch (state.message) {
                case ReportsMessage.emergencyVisitRequested:
                  state.message = null;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Success',
                          style: CustomStyle.smallTextBWhite,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  });
                  break;
                default:
                  break;
              }
            }
            if (state.error != null && state.error!.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!, textAlign: TextAlign.center),
                  ),
                );
              });
            }
            _canRequestEmergencyVisit = state.user is Client;
            return _buildBody(state);
          }
          _canRequestEmergencyVisit = false;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _openRequestBottomSheet(BuildContext parentContext) {
    final l10n = AppLocalizations.of(parentContext)!;
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext ctx) {
        return BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            if (state is! ReportsAuthenticated) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            ContractData? contract;
            try {
              contract = state.contracts
                  ?.firstWhere((c) => c.metaData.id == widget.contractId);
            } catch (_) {
              contract = null;
            }

            final companyName =
                contract?.metaData.employee?.branch.company.name ?? '';
            final branchName = contract?.metaData.employee?.branch.name ?? '';
            final employeeName = contract?.metaData.employee?.info.name ?? '';
            final currentUserName = _currentUserName(state.user);

            final formKey = GlobalKey<FormState>();
            final descriptionController = TextEditingController();

            Widget rowItem(String label, String value) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(label, style: CustomStyle.smallTextBRed),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        value.isNotEmpty ? value : '-',
                        style: CustomStyle.smallText,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.emergency,
                              color: CustomStyle.redDark),
                          const SizedBox(width: 8),
                          Text(
                            l10n.emergency_visit_request,
                            style: CustomStyle.mediumTextBRed,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      rowItem('Contract ID', widget.contractId),
                      rowItem('Company', companyName),
                      rowItem('Branch', branchName),
                      rowItem('Employee', employeeName),
                      rowItem('Requested by', currentUserName),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Description *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomStyle.redDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          Navigator.of(ctx).pop();
                          parentContext.read<ReportsBloc>().add(
                                RequestEmergencyVisitRequested(
                                  contractId: widget.contractId,
                                  description:
                                      descriptionController.text.trim(),
                                ),
                              );
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Submit request'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _currentUserName(dynamic userRole) {
    try {
      final info = (userRole as dynamic).info;
      final name = (info as dynamic).name?.toString() ?? '';
      return name.isNotEmpty ? name : '-';
    } catch (_) {
      return '-';
    }
  }

  Widget _buildBody(ReportsAuthenticated state) {
    final l10n = AppLocalizations.of(context)!;
    String prettyStatus(EmergencyVisitStatus s) {
      switch (s) {
        case EmergencyVisitStatus.pending:
          return l10n.status_pending;
        case EmergencyVisitStatus.approved:
          return l10n.status_approved;
        case EmergencyVisitStatus.rejected:
          return l10n.status_rejected;
        case EmergencyVisitStatus.completed:
          return l10n.status_completed;
        case EmergencyVisitStatus.cancelled:
          return l10n.status_canceled;
      }
    }

    _EmergencyVisitStatusFilterOption selectedFilterOption() {
      switch (_statusFilter) {
        case null:
          return _EmergencyVisitStatusFilterOption.all;
        case EmergencyVisitStatus.pending:
          return _EmergencyVisitStatusFilterOption.pending;
        case EmergencyVisitStatus.approved:
          return _EmergencyVisitStatusFilterOption.approved;
        case EmergencyVisitStatus.rejected:
          return _EmergencyVisitStatusFilterOption.rejected;
        case EmergencyVisitStatus.completed:
          return _EmergencyVisitStatusFilterOption.completed;
        case EmergencyVisitStatus.cancelled:
          return _EmergencyVisitStatusFilterOption.cancelled;
      }
    }

    EmergencyVisitStatus? optionToStatus(_EmergencyVisitStatusFilterOption o) {
      switch (o) {
        case _EmergencyVisitStatusFilterOption.all:
          return null;
        case _EmergencyVisitStatusFilterOption.pending:
          return EmergencyVisitStatus.pending;
        case _EmergencyVisitStatusFilterOption.approved:
          return EmergencyVisitStatus.approved;
        case _EmergencyVisitStatusFilterOption.rejected:
          return EmergencyVisitStatus.rejected;
        case _EmergencyVisitStatusFilterOption.completed:
          return EmergencyVisitStatus.completed;
        case _EmergencyVisitStatusFilterOption.cancelled:
          return EmergencyVisitStatus.cancelled;
      }
    }

    final statusLabel = _statusFilter == null
        ? l10n.emergency_visit_filter_status_all
        : prettyStatus(_statusFilter!);

    final emergencyVisits = (state.emergencyVisits ??
            const <EmergencyVisitData>[])
        .where((e) => e.contractId == widget.contractId)
        .where((e) => _statusFilter == null || e.status == _statusFilter)
        .toList()
      ..sort(
        (a, b) => _sortOldToNew
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt),
      );
    final label = _sortOldToNew ? l10n.sort_old_to_new : l10n.sort_new_to_old;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      setState(() => _sortOldToNew = !_sortOldToNew),
                  icon: const Icon(Icons.sort, size: 18),
                  label: Text(label),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CustomStyle.redDark,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                PopupMenuButton<_EmergencyVisitStatusFilterOption>(
                  initialValue: selectedFilterOption(),
                  onSelected: (o) =>
                      setState(() => _statusFilter = optionToStatus(o)),
                  itemBuilder: (context) => [
                    PopupMenuItem<_EmergencyVisitStatusFilterOption>(
                      value: _EmergencyVisitStatusFilterOption.all,
                      child: Text(l10n.emergency_visit_filter_status_all),
                    ),
                    PopupMenuItem<_EmergencyVisitStatusFilterOption>(
                      value: _EmergencyVisitStatusFilterOption.pending,
                      child: Text(prettyStatus(EmergencyVisitStatus.pending)),
                    ),
                    PopupMenuItem<_EmergencyVisitStatusFilterOption>(
                      value: _EmergencyVisitStatusFilterOption.approved,
                      child: Text(prettyStatus(EmergencyVisitStatus.approved)),
                    ),
                    PopupMenuItem<_EmergencyVisitStatusFilterOption>(
                      value: _EmergencyVisitStatusFilterOption.rejected,
                      child: Text(prettyStatus(EmergencyVisitStatus.rejected)),
                    ),
                    PopupMenuItem<_EmergencyVisitStatusFilterOption>(
                      value: _EmergencyVisitStatusFilterOption.completed,
                      child: Text(prettyStatus(EmergencyVisitStatus.completed)),
                    ),
                    PopupMenuItem<_EmergencyVisitStatusFilterOption>(
                      value: _EmergencyVisitStatusFilterOption.cancelled,
                      child: Text(prettyStatus(EmergencyVisitStatus.cancelled)),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.filter_alt_outlined,
                          size: 18,
                          color: CustomStyle.redDark,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${l10n.emergency_visit_filter_status_label}: $statusLabel',
                          style: CustomStyle.smallTextB
                              .copyWith(color: CustomStyle.redDark),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: CustomStyle.redDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: emergencyVisits.isEmpty
                ? CustomEmpty(message: l10n.no_contracts_yet)
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: emergencyVisits.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final visit = emergencyVisits[i];
                      final requestedByName = _findUserName(
                          visit.requestedBy, state.employees, state.clients);
                      return EmergencyVisitSummary(
                        emergencyVisit: visit,
                        createdAtText: DateLocalizations.of(visit.createdAt),
                        requestedByName: requestedByName,
                        onTap: () {
                          ContractData? contract;
                          try {
                            contract = state.contracts?.firstWhere(
                                (c) => c.metaData.id == visit.contractId);
                          } catch (_) {
                            contract = null;
                          }
                          final companyName = contract
                                  ?.metaData.employee?.branch.company.name ??
                              '';
                          final branchName =
                              contract?.metaData.employee?.branch.name ?? '';
                          final employeeName =
                              contract?.metaData.employee?.info.name ?? '';
                          Navigator.of(ctx).push(
                            MaterialPageRoute(
                              builder: (_) => EmergencyVisitDetailsScreen(
                                emergencyVisitId: visit.id,
                                contractId: visit.contractId,
                                companyName: companyName,
                                branchName: branchName,
                                employeeName: employeeName,
                                requestedByName: requestedByName,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _findUserName(
      String userId, List<Employee>? employees, List<Client>? clients) {
    try {
      final e = (employees ?? const <Employee>[])
          .firstWhere((x) => x.info.id == userId);
      return e.info.name;
    } catch (_) {}
    try {
      final c =
          (clients ?? const <Client>[]).firstWhere((x) => x.info.id == userId);
      return c.info.name;
    } catch (_) {}
    return userId;
  }

  // Status chip UI moved into EmergencyVisitSummary to match VisitReportSummary style.
}
