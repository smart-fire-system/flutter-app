import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/screens/reports/view/contract_details_screen.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/helper.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';

class ContractSummary extends StatefulWidget {
  final ContractData contract;
  final VoidCallback? onTap;
  final bool showViewContractButton;

  const ContractSummary(
      {super.key,
      required this.contract,
      this.onTap,
      this.showViewContractButton = false});
  @override
  State<ContractSummary> createState() => _ContractSummaryState();
}

class _ContractSummaryState extends State<ContractSummary> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with contract number and state chip (match list style)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (widget.contract.paramContractNumber?.isNotEmpty == true)
                          ? l10n.contract_number_prefix(
                              widget.contract.paramContractNumber!)
                          : (widget.contract.metaData.code != null
                              ? l10n.contract_number_prefix(
                                  widget.contract.metaData.code.toString())
                              : l10n.contract_label),
                      style: CustomStyle.mediumTextBRed,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _stateColor(widget.contract.metaData.state)
                          .withValues(alpha: 0.1),
                      border: Border.all(
                        color: _stateColor(widget.contract.metaData.state),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _stateLabel(widget.contract.metaData.state),
                      style: CustomStyle.smallTextB.copyWith(
                        color: _stateColor(widget.contract.metaData.state),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Dates row
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      size: 18, color: CustomStyle.redDark),
                  const SizedBox(width: 6),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.period_from,
                          style: CustomStyle.smallTextBRed,
                        ),
                        TextSpan(
                          text: DateHelper.formatDate(
                              widget.contract.metaData.startDate),
                          style: CustomStyle.smallText,
                        ),
                        TextSpan(
                          text: l10n.period_to,
                          style: CustomStyle.smallTextBRed,
                        ),
                        TextSpan(
                          text: DateHelper.formatDate(
                              widget.contract.metaData.endDate),
                          style: CustomStyle.smallText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Employee
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 18, color: CustomStyle.redDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: l10n.employee_label,
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text:
                                widget.contract.metaData.employee?.info.name ??
                                    '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Client
              Row(
                children: [
                  const Icon(Icons.group_outlined,
                      size: 18, color: CustomStyle.redDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: l10n.client_label,
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: widget.contract.metaData.client?.info.name ??
                                '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Branch
              Row(
                children: [
                  const Icon(Icons.apartment_outlined,
                      size: 18, color: CustomStyle.redDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: l10n.branch_label,
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: widget
                                    .contract.metaData.employee?.branch.name ??
                                '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.visibility_outlined,
                      size: 18, color: CustomStyle.redDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Builder(builder: (context) {
                      final names = _resolveSharedWithNames();
                      if (names.isEmpty) {
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Shared with: ',
                                style: CustomStyle.smallTextBRed,
                              ),
                              TextSpan(
                                text: '-',
                                style: CustomStyle.smallText,
                              ),
                            ],
                          ),
                        );
                      }
                      final String first = names.first;
                      final int others = names.length - 1;
                      final String summary = others > 0
                          ? '$first and $others other${others > 1 ? 's' : ''}'
                          : first;
                      return Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Shared with: ',
                              style: CustomStyle.smallTextBRed,
                            ),
                            TextSpan(
                              text: summary,
                              style: CustomStyle.smallText,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined,
                        color: CustomStyle.greyDark, size: 20),
                    onPressed: () => _showSharedWithBottomSheet(context),
                    tooltip: 'View all',
                  ),
                ],
              ),
              if (widget.showViewContractButton)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContractDetailsScreen(
                            contractId: widget.contract.metaData.id!),
                      ),
                    ),
                    icon: const Icon(Icons.visibility),
                    label: Text(l10n.view_contract),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _resolveSharedWithNames() {
    List<String> names = [];
    for (var sharedWith in widget.contract.sharedWithClients) {
      names.add(sharedWith.info.name);
    }
    for (var sharedWith in widget.contract.sharedWithEmployees) {
      names.add(sharedWith.info.name);
    }
    return names;
  }

  void _showSharedWithBottomSheet(BuildContext context) {
    final clients = widget.contract.sharedWithClients;
    final employees = widget.contract.sharedWithEmployees;
    final bool hasAny = clients.isNotEmpty || employees.isNotEmpty;
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.visibility_outlined,
                      color: CustomStyle.redDark),
                  const SizedBox(width: 8),
                  Text(
                    'Shared with: ',
                    style: CustomStyle.mediumTextBRed,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!hasAny)
                const Text(
                  'No users',
                  style: TextStyle(color: CustomStyle.greyDark),
                )
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      if (clients.isNotEmpty) ...[
                        Text(
                          'Clients',
                          style: CustomStyle.smallTextBRed,
                        ),
                        const SizedBox(height: 6),
                        ...clients.map((c) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child: Text(
                                  c.info.name.trim().isNotEmpty
                                      ? c.info.name.trim()[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      color: CustomStyle.redDark),
                                ),
                              ),
                              title: Text(c.info.name),
                              subtitle: Text('Code: ${c.info.code}'),
                            )),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                      ],
                      if (employees.isNotEmpty) ...[
                        Text(
                          'Employees',
                          style: CustomStyle.smallTextBRed,
                        ),
                        const SizedBox(height: 6),
                        ...employees.map((e) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child: Text(
                                  e.info.name.trim().isNotEmpty
                                      ? e.info.name.trim()[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      color: CustomStyle.redDark),
                                ),
                              ),
                              title: Text(e.info.name),
                              subtitle: Text('Code: ${e.info.code}'),
                            )),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _stateColor(ContractState? state) {
    switch (state) {
      case ContractState.active:
        if (ContractsCommon.isContractExpired(widget.contract)) {
          return Colors.red;
        }
        return Colors.green;
      case ContractState.pendingClient:
        return Colors.orange;
      case ContractState.requestCancellation:
        return Colors.deepOrange;
      case ContractState.expired:
        return Colors.grey;
      case ContractState.cancelled:
        return Colors.red;
      case ContractState.draft:
      default:
        return Colors.blueGrey;
    }
  }

  String _stateLabel(ContractState? state) {
    final l10n = AppLocalizations.of(context)!;
    switch (state) {
      case ContractState.active:
        if (ContractsCommon.isContractExpired(widget.contract)) {
          return l10n.linear_stage_expired;
        }
        return l10n.linear_stage_active;
      case ContractState.pendingClient:
        return l10n.contract_wait_other_client_sign_title;
      case ContractState.requestCancellation:
        return l10n.cancel;
      case ContractState.expired:
        return l10n.linear_stage_expired;
      case ContractState.cancelled:
        return l10n.cancelled;
      case ContractState.draft:
      default:
        return l10n.linear_stage_draft;
    }
  }
}
