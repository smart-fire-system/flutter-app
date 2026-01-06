import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
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

            return Column(
              children: [
                _buildHeader(context, visit),
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
              visit.status.name,
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
          rowItem('Contract ID', widget.contractId),
          rowItem('Company', widget.companyName),
          rowItem('Branch', widget.branchName),
          rowItem('Employee', widget.employeeName),
          rowItem('Requested by', widget.requestedByName),
          rowItem('Created at', _formatTimestamp(visit.createdAt)),
          rowItem('Description', visit.description),
          const Divider(height: 22),
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
                  const SizedBox(height: 4),
                  Text(
                    c.comment,
                    style: isMe
                        ? CustomStyle.normalButtonTextSmallWhite
                        : CustomStyle.smallText,
                  ),
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
}
