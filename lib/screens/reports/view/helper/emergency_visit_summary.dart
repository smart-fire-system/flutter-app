import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/emergency_visit.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';

class EmergencyVisitSummary extends StatelessWidget {
  final EmergencyVisitData emergencyVisit;
  final int index;
  final String createdAtText;
  final String requestedByName;
  final VoidCallback? onTap;

  const EmergencyVisitSummary({
    super.key,
    required this.emergencyVisit,
    required this.index,
    required this.createdAtText,
    required this.requestedByName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final _StatusTheme statusTheme = _statusTheme(emergencyVisit.status);
    String pretty(EmergencyVisitStatus s) {
      switch (s) {
        case EmergencyVisitStatus.pending:
          return AppLocalizations.of(context)!.status_pending;
        case EmergencyVisitStatus.approved:
          return AppLocalizations.of(context)!.status_approved;
        case EmergencyVisitStatus.rejected:
          return AppLocalizations.of(context)!.status_rejected;
        case EmergencyVisitStatus.completed:
          return AppLocalizations.of(context)!.status_completed;
        case EmergencyVisitStatus.cancelled:
          return AppLocalizations.of(context)!.status_canceled;
      }
    }

    return GestureDetector(
      onTap: onTap,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!
                          .emergency_visit_request_no(index + 1),
                      style: CustomStyle.mediumTextBRed,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusTheme.bg,
                      border: Border.all(color: statusTheme.bg, width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      pretty(emergencyVisit.status),
                      style: CustomStyle.smallTextB.copyWith(
                        color: statusTheme.fg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.event_available,
                      size: 18, color: CustomStyle.redDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${S.of(context).createdAt}: ',
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text:
                                createdAtText.isNotEmpty ? createdAtText : '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
                            text: 'Requested by: ',
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: requestedByName.isNotEmpty
                                ? requestedByName
                                : emergencyVisit.requestedBy,
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
                            text: 'Last updated: ',
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: emergencyVisit.comments.isNotEmpty
                                ? TimeAgoHelper.of(
                                    context,
                                    format: TimeAgoFormat.long,
                                    emergencyVisit.comments.last.createdAt)
                                : 'No updates yet',
                            style: CustomStyle.smallText,
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

  _StatusTheme _statusTheme(EmergencyVisitStatus status) {
    switch (status) {
      case EmergencyVisitStatus.pending:
        return _StatusTheme(bg: Colors.orange.shade50, fg: Colors.orange);
      case EmergencyVisitStatus.approved:
        return _StatusTheme(bg: Colors.blue.shade50, fg: Colors.blue);
      case EmergencyVisitStatus.rejected:
        return _StatusTheme(bg: Colors.red.shade50, fg: Colors.red);
      case EmergencyVisitStatus.completed:
        return _StatusTheme(bg: Colors.green.shade50, fg: Colors.green);
      case EmergencyVisitStatus.cancelled:
        return _StatusTheme(bg: Colors.grey.shade50, fg: Colors.grey);
    }
  }
}

class _StatusTheme {
  final Color bg;
  final Color fg;
  _StatusTheme({required this.bg, required this.fg});
}
