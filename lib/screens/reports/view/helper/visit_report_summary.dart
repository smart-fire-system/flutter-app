import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';

class VisitReportSummary extends StatefulWidget {
  final VisitReportData visitReport;
  final int index;
  final VoidCallback? onTap;

  const VisitReportSummary({
    super.key,
    required this.visitReport,
    required this.index,
    this.onTap,
  });
  @override
  State<VisitReportSummary> createState() => _VisitReportSummaryState();
}

class _VisitReportSummaryState extends State<VisitReportSummary> {
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
                      (l10n.system_report_no(widget.index + 1)),
                      style: CustomStyle.mediumTextBRed,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.visitReport.employeeSignature.id != null &&
                              widget.visitReport.clientSignature.id != null
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      border: Border.all(
                        color: widget.visitReport.employeeSignature.id !=
                                    null &&
                                widget.visitReport.clientSignature.id != null
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.visitReport.employeeSignature.id != null &&
                              widget.visitReport.clientSignature.id != null
                          ? l10n.signed
                          : l10n.not_signed,
                      style: CustomStyle.smallTextB.copyWith(
                        color: widget.visitReport.employeeSignature.id !=
                                    null &&
                                widget.visitReport.clientSignature.id != null
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Dates row
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
                            text: l10n.visit_date,
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: widget.visitReport.paramVisitDate ?? '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Employee
              Row(
                children: [
                  const Icon(Icons.sensors,
                      size: 18, color: CustomStyle.redDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: l10n.system_status,
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text:
                                widget.visitReport.paramSystemStatusBool == '1'
                                    ? l10n.suitable
                                    : l10n.unsuitable,
                            style: CustomStyle.smallText.copyWith(
                              color: widget.visitReport.paramSystemStatusBool ==
                                      '1'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
