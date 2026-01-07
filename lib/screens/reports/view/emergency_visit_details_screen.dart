import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/emergency_visit.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmergencyVisitDetailsScreen extends StatefulWidget {
  final String emergencyVisitId;
  final String contractId;
  final String companyName;
  final String branchName;
  final String employeeName;
  final String requestedByName;

  const EmergencyVisitDetailsScreen({
    super.key,
    required this.emergencyVisitId,
    required this.contractId,
    required this.companyName,
    required this.branchName,
    required this.employeeName,
    required this.requestedByName,
  });

  @override
  State<EmergencyVisitDetailsScreen> createState() =>
      _EmergencyVisitDetailsScreenState();
}

class _EmergencyVisitDetailsScreenState
    extends State<EmergencyVisitDetailsScreen> {
  final _formatter = DateFormat('dd/MM/yyyy - hh:mm a');
  final _scrollController = ScrollController();
  final _commentController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).emergency_visits),
      body: SafeArea(
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            if (state is! ReportsAuthenticated) {
              return const Center(child: CircularProgressIndicator());
            }

            final visit =
                (state.emergencyVisits ?? const <EmergencyVisitData>[])
                    .cast<EmergencyVisitData?>()
                    .firstWhere(
                      (e) => e?.id == widget.emergencyVisitId,
                      orElse: () => null,
                    );

            if (visit == null) {
              return Center(
                child: Text(
                  'Not found',
                  style: CustomStyle.mediumTextBRed,
                ),
              );
            }

            final currentUserId = _currentUserId(state.user);
            final comments = [...visit.comments]
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

            final allowedNextStatuses =
                _allowedNextStatusesForVisit(state, visit);

            return Column(
              children: [
                _buildHeader(context, visit),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildStatusTrackers(
                    createdAt: visit.createdAt,
                    comments: visit.comments,
                    changeOptions: allowedNextStatuses,
                    onChangeTap: allowedNextStatuses.isEmpty
                        ? null
                        : () => _openStatusBottomSheet(
                              context,
                              visitId: visit.id,
                              currentStatus: visit.status,
                              options: allowedNextStatuses,
                            ),
                  ),
                ),
                _buildRequestInfo(context, visit),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildCommentsList(
                    context,
                    comments: comments,
                    employees: state.employees,
                    clients: state.clients,
                    currentUserId: currentUserId,
                  ),
                ),
                _buildComposer(context, visitId: visit.id),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, EmergencyVisitData visit) {
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Request #${visit.code}',
              style: CustomStyle.mediumTextBRed,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: CustomStyle.redDark.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: CustomStyle.redDark.withValues(alpha: 0.2)),
            ),
            child: Text(
              pretty(visit.status),
              style:
                  CustomStyle.smallTextB.copyWith(color: CustomStyle.redDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestInfo(BuildContext context, EmergencyVisitData visit) {
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowItem('Requested by', widget.requestedByName),
          rowItem('Description', visit.description),
          Text('Comments', style: CustomStyle.mediumTextBRed),
        ],
      ),
    );
  }

  Widget _buildCommentsList(
    BuildContext context, {
    required List<CommentData> comments,
    required List<Employee>? employees,
    required List<Client>? clients,
    required String currentUserId,
  }) {
    if (comments.isEmpty) {
      return Center(
        child: Text(
          'No comments yet',
          style: CustomStyle.smallText,
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      itemCount: comments.length,
      itemBuilder: (ctx, i) {
        final c = comments[i];
        final isMe = c.userId == currentUserId;
        final userName = _findUserName(c.userId, employees, clients);
        final hasTextComment = c.comment.trim().isNotEmpty;

        if (c.oldStatus != c.newStatus) {
          String pretty(EmergencyVisitStatus s) {
            switch (s) {
              case EmergencyVisitStatus.pending:
                return AppLocalizations.of(context)!.status_created;
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

          final newText = pretty(c.newStatus);
          final dateText = _formatTimestamp(c.createdAt);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  '$dateText\n$userName changed status to ($newText)',
                  textAlign: TextAlign.center,
                  style: CustomStyle.smallText.copyWith(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          );
        }

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? CustomStyle.redDark : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: (isMe
                            ? CustomStyle.smallTextBWhite
                            : CustomStyle.smallTextBRed)
                        .copyWith(fontSize: 12),
                  ),
                  if (hasTextComment) ...[
                    const SizedBox(height: 4),
                    Text(
                      c.comment,
                      style: isMe
                          ? CustomStyle.normalButtonTextSmallWhite
                          : CustomStyle.smallText,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    _formatTimestamp(c.createdAt),
                    style: (isMe
                            ? CustomStyle.normalButtonTextSmallWhite
                            : CustomStyle.smallText)
                        .copyWith(
                            fontSize: 11,
                            color: isMe ? Colors.white70 : Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildComposer(BuildContext context, {required String visitId}) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 44,
            width: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: CustomStyle.redDark,
                shape: const CircleBorder(),
              ),
              onPressed: _sending
                  ? null
                  : () async {
                      final text = _commentController.text.trim();
                      if (text.isEmpty) return;
                      setState(() => _sending = true);
                      try {
                        context.read<ReportsBloc>().add(
                              AddEmergencyVisitCommentRequested(
                                emergencyVisitId: visitId,
                                comment: text,
                              ),
                            );
                        _commentController.clear();
                        await Future<void>.delayed(
                            const Duration(milliseconds: 250));
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _sending = false);
                      }
                    },
              child: _sending
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp ts) {
    final dt = ts.toDate();
    return _formatter.format(dt.toLocal());
  }

  String _currentUserId(dynamic userRole) {
    try {
      final info = (userRole as dynamic).info;
      final id = (info as dynamic).id?.toString() ?? '';
      return id;
    } catch (_) {
      return '';
    }
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

  List<EmergencyVisitStatus> _allowedNextStatuses(
    EmergencyVisitStatus current,
    bool isRequester,
    bool isEmployeeAllowed,
  ) {
    final out = <EmergencyVisitStatus>[];

    // (1) Requester rules
    if (isRequester) {
      if (current == EmergencyVisitStatus.pending) {
        out.add(EmergencyVisitStatus.cancelled);
      }
      if (current == EmergencyVisitStatus.rejected) {
        out.add(EmergencyVisitStatus.cancelled);
      }
    }

    // (2) Employee rules (contract employee OR employee in sharedWith)
    if (isEmployeeAllowed) {
      if (current == EmergencyVisitStatus.pending) {
        out.add(EmergencyVisitStatus.approved);
        out.add(EmergencyVisitStatus.rejected);
      }
      if (current == EmergencyVisitStatus.approved) {
        out.add(EmergencyVisitStatus.completed);
      }
    }

    // de-dupe while keeping order
    final seen = <EmergencyVisitStatus>{};
    return out.where((s) => seen.add(s)).toList();
  }

  Future<void> _openStatusBottomSheet(
    BuildContext context, {
    required String visitId,
    required EmergencyVisitStatus currentStatus,
    required List<EmergencyVisitStatus> options,
  }) async {
    EmergencyVisitStatus? selected;

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

    final result = await showModalBottomSheet<EmergencyVisitStatus?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tune, color: CustomStyle.redDark),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Change Status',
                            style: CustomStyle.mediumTextBRed,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(null),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Text('Current:', style: CustomStyle.smallTextBRed),
                          const SizedBox(width: 8),
                          Text(pretty(currentStatus),
                              style: CustomStyle.smallText),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('New status', style: CustomStyle.smallTextBRed),
                    const SizedBox(height: 6),
                    ...options.map((s) {
                      final isSelected = selected == s;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setModalState(() => selected = s),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? CustomStyle.redDark
                                  : Colors.grey.shade300,
                            ),
                            color: isSelected
                                ? CustomStyle.redDark.withValues(alpha: 0.06)
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.name,
                                  style: CustomStyle.smallText,
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle,
                                    color: CustomStyle.redDark),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomStyle.redDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: selected == null
                          ? null
                          : () => Navigator.of(ctx).pop(selected),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) return;
    if (!context.mounted) return;
    context.read<ReportsBloc>().add(
          ChangeEmergencyVisitStatusRequested(
            emergencyVisitId: visitId,
            newStatus: result,
          ),
        );
  }

  Widget _buildStatusTrackers({
    required Timestamp createdAt,
    required List<CommentData> comments,
    required List<EmergencyVisitStatus> changeOptions,
    required VoidCallback? onChangeTap,
  }) {
    final changes = comments.where((c) => c.newStatus != c.oldStatus).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    String pretty(EmergencyVisitStatus s) {
      switch (s) {
        case EmergencyVisitStatus.pending:
          return AppLocalizations.of(context)!.status_created;
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

    // Step 1 is always created.
    final step1 = _TrackerStep(label: 'Created', date: createdAt);

    // Default: no changes yet -> steps show '-'
    _TrackerStep step2 = _TrackerStep(label: '-', date: null);
    _TrackerStep step3 = _TrackerStep(label: '-', date: null);

    if (changes.isNotEmpty) {
      final first = changes.first;
      if (first.newStatus != EmergencyVisitStatus.pending) {
        final isIntermediate =
            first.newStatus == EmergencyVisitStatus.approved ||
                first.newStatus == EmergencyVisitStatus.rejected;

        if (isIntermediate) {
          step2 = _TrackerStep(
              label: pretty(first.newStatus), date: first.createdAt);
          if (changes.length >= 2) {
            final last = changes.last;
            if (last.newStatus != first.newStatus) {
              step3 = _TrackerStep(
                  label: pretty(last.newStatus), date: last.createdAt);
            }
          }
        } else {
          // Direct final change like pending -> cancelled (or completed).
          // Step2 should be marked done but with empty text, step3 is final status.
          step2 = _TrackerStep(label: '', date: first.createdAt);
          step3 = _TrackerStep(
              label: pretty(first.newStatus), date: first.createdAt);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (onChangeTap != null && changeOptions.isNotEmpty)
              OutlinedButton.icon(
                onPressed: onChangeTap,
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Change status'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CustomStyle.redDark,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _StatusFlowTracker(
          title: '',
          steps: [step1, step2, step3],
          formatDate: _formatTimestamp,
        ),
      ],
    );
  }

  List<EmergencyVisitStatus> _allowedNextStatusesForVisit(
    ReportsAuthenticated state,
    EmergencyVisitData visit,
  ) {
    ContractData? contract;
    try {
      contract =
          state.contracts?.firstWhere((c) => c.metaData.id == visit.contractId);
    } catch (_) {
      contract = null;
    }

    final currentUserId = _currentUserId(state.user);
    final contractEmployeeId = contract?.metaData.employeeId ??
        contract?.metaData.employee?.info.id ??
        '';
    final sharedWithIds = (contract?.sharedWith ?? const <dynamic>[])
        .map((e) => e.toString())
        .toList();

    final bool isRequester =
        currentUserId.isNotEmpty && currentUserId == visit.requestedBy;
    final bool isEmployee = state.user is Employee;
    final bool isContractEmployee = isEmployee &&
        currentUserId.isNotEmpty &&
        currentUserId == contractEmployeeId;
    final bool isSharedEmployee = isEmployee &&
        currentUserId.isNotEmpty &&
        sharedWithIds.contains(currentUserId);

    return _allowedNextStatuses(
      visit.status,
      isRequester,
      isContractEmployee || isSharedEmployee,
    );
  }
}

class _TrackerStep {
  final String label;
  final Timestamp? date;
  _TrackerStep({required this.label, required this.date});
}

class _StatusFlowTracker extends StatelessWidget {
  final String title;
  final List<_TrackerStep> steps;
  final String Function(Timestamp ts) formatDate;

  const _StatusFlowTracker({
    required this.title,
    required this.steps,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = CustomStyle.redDark;
    final inactiveColor = Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.trim().isNotEmpty) ...[
            Text(title, style: CustomStyle.smallTextBRed),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                _TrackerNode(
                  label: steps[i].label,
                  date: steps[i].date,
                  isDone: steps[i].date != null,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  formatDate: formatDate,
                ),
                if (i != steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: (steps[i + 1].date != null)
                          ? activeColor
                          : inactiveColor,
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackerNode extends StatelessWidget {
  final String label;
  final Timestamp? date;
  final bool isDone;
  final Color activeColor;
  final Color inactiveColor;
  final String Function(Timestamp ts) formatDate;

  const _TrackerNode({
    required this.label,
    required this.date,
    required this.isDone,
    required this.activeColor,
    required this.inactiveColor,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final circleColor = isDone ? activeColor : inactiveColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: CustomStyle.smallText.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          width: 90,
          child: Text(
            date != null ? formatDate(date!) : '',
            textAlign: TextAlign.center,
            style: CustomStyle.smallText
                .copyWith(fontSize: 10, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
