import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/emergency_visit.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/emergency_visit_summary.dart';
import 'package:fire_alarm_system/screens/reports/view/emergency_visit_details_screen.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmergencyVisitsScreen extends StatefulWidget {
  final String contractId;
  const EmergencyVisitsScreen({super.key, required this.contractId});

  @override
  State<EmergencyVisitsScreen> createState() => _EmergencyVisitsScreenState();
}

class _EmergencyVisitsScreenState extends State<EmergencyVisitsScreen> {
  final _formatter = DateFormat('dd/MM/yyyy - hh:mm a');
  bool _sortOldToNew = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.emergency_visits),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          l10n.emergency_visit_request,
          style: CustomStyle.mediumTextWhite,
        ),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () => _openRequestBottomSheet(context),
      ),
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
            return _buildBody(state);
          }
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
    final emergencyVisits = (state.emergencyVisits ??
            const <EmergencyVisitData>[])
        .where((e) => e.contractId == widget.contractId)
        .toList()
      ..sort(
        (a, b) => _sortOldToNew
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt),
      );

    if (emergencyVisits.isEmpty) {
      return CustomEmpty(message: l10n.no_contracts_yet);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: emergencyVisits.length + 1,
      separatorBuilder: (_, i) =>
          i == 0 ? const SizedBox(height: 16) : const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        if (i == 0) {
          final label = _sortOldToNew
              ? l10n.sort_old_to_new
              : l10n.sort_new_to_old;
          return Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _sortOldToNew = !_sortOldToNew),
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
          );
        }

        final visit = emergencyVisits[i - 1];
        final requestedByName =
            _findUserName(visit.requestedBy, state.employees, state.clients);
        return EmergencyVisitSummary(
          emergencyVisit: visit,
          createdAtText: _formatTimestamp(visit.createdAt),
          requestedByName: requestedByName,
          onTap: () {
            ContractData? contract;
            try {
              contract = state.contracts
                  ?.firstWhere((c) => c.metaData.id == visit.contractId);
            } catch (_) {
              contract = null;
            }
            final companyName =
                contract?.metaData.employee?.branch.company.name ?? '';
            final branchName = contract?.metaData.employee?.branch.name ?? '';
            final employeeName = contract?.metaData.employee?.info.name ?? '';
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
    );
  }

  String _formatTimestamp(Timestamp ts) {
    final dt = ts.toDate();
    return _formatter.format(dt.toLocal());
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
