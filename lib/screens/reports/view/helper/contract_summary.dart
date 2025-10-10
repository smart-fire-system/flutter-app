import 'package:fire_alarm_system/generated/l10n.dart';
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
                          ? S.of(context).contract_number_prefix(
                              widget.contract.paramContractNumber!)
                          : (widget.contract.metaData.code != null
                              ? S.of(context).contract_number_prefix(
                                  widget.contract.metaData.code.toString())
                              : S.of(context).contract_label),
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
                          text: S.of(context).period_from,
                          style: CustomStyle.smallTextBRed,
                        ),
                        TextSpan(
                          text: DateHelper.formatDate(
                              widget.contract.metaData.startDate),
                          style: CustomStyle.smallText,
                        ),
                        TextSpan(
                          text: S.of(context).period_to,
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
                            text: S.of(context).employee_label,
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
                            text: S.of(context).client_label,
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
                            text: S.of(context).branch_label,
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
                    label: Text(S.of(context).view_contract),
                  ),
                ),
            ],
          ),
        ),
      ),
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
    switch (state) {
      case ContractState.active:
        if (ContractsCommon.isContractExpired(widget.contract)) {
          return S.of(context).linear_stage_expired;
        }
        return S.of(context).linear_stage_active;
      case ContractState.pendingClient:
        return S.of(context).contract_wait_other_client_sign_title;
      case ContractState.requestCancellation:
        return S.of(context).cancel;
      case ContractState.expired:
        return S.of(context).linear_stage_expired;
      case ContractState.cancelled:
        return S.of(context).cancelled;
      case ContractState.draft:
      default:
        return S.of(context).linear_stage_draft;
    }
  }
}
