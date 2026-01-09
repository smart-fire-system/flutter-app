import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/visit_report_details.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/visit_report_summary.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/models/contract_data.dart';

class ViewVisitReportScreen extends StatefulWidget {
  final String visitReportId;

  const ViewVisitReportScreen({
    super.key,
    required this.visitReportId,
  });

  @override
  State<ViewVisitReportScreen> createState() => _ViewVisitReportScreenState();
}

class _ViewVisitReportScreenState extends State<ViewVisitReportScreen> {
  late ContractData _contract;
  late VisitReportData _visitReport;
  late dynamic _user;

  bool _isPendingCurrentEmployeeSign() {
    if (_user is! Employee) return false;
    return _visitReport.employeeSignature.id == null &&
        _visitReport.employeeId == (_user as Employee).info.id;
  }

  bool _isPendingOtherEmployeeSign() {
    return _visitReport.employeeSignature.id == null;
  }

  bool _isPendingCurrentClientSign() {
    if (_user is! Client) return false;
    return _visitReport.clientSignature.id == null &&
        _visitReport.contractMetaData.clientId == (_user as Client).info.id;
  }

  bool _isPendingOtherClientSign() {
    return _visitReport.clientSignature.id == null;
  }

  Widget _buildStateCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    late Color cardColor;
    late Color borderColor;
    late String title;
    late String subtitle;
    if (_isPendingCurrentEmployeeSign()) {
      cardColor = Colors.red.shade50;
      borderColor = CustomStyle.redLight;
      title = l10n.sign_employee_required_title;
      subtitle = l10n.sign_employee_required_subtitle;
    } else if (_isPendingOtherEmployeeSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      title = l10n.waiting_employee_signature_title;
      subtitle = l10n.waiting_employee_signature_subtitle;
    } else if (_isPendingCurrentClientSign()) {
      cardColor = Colors.red.shade50;
      borderColor = CustomStyle.redLight;
      title = l10n.sign_client_required_title;
      subtitle = l10n.visit_report_wait_client_sign_subtitle;
    } else if (_isPendingOtherClientSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      title = l10n.contract_wait_other_client_sign_title;
      subtitle = l10n.visit_report_wait_other_client_sign_subtitle;
    } else {
      cardColor = Colors.green.shade50;
      borderColor = Colors.greenAccent;
      title = l10n.visit_reports;
      subtitle = l10n.signed;
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomStyle.mediumTextBRed,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: CustomStyle.smallText,
                  ),
                  const SizedBox(height: 10),
                  _buildLinearStateDiagram(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignActionCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool canEmployeeSign = _isPendingCurrentEmployeeSign();
    final bool canClientSign = _isPendingCurrentClientSign();
    if (!canEmployeeSign && !canClientSign) return const SizedBox.shrink();

    final String title = canEmployeeSign
        ? l10n.signature_employee_title
        : l10n.signature_client_title;
    final String subtitle = l10n.signature_confirm_dialog_body;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: CustomStyle.redLight, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showSignConfirmBottomSheet(context, title: title);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: CustomStyle.redLight.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.edit_document, color: CustomStyle.redDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CustomStyle.mediumTextBRed,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: CustomStyle.greyDark),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_left,
                  color: CustomStyle.greyDark),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignConfirmBottomSheet(BuildContext context,
      {required String title}) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext ctx) {
        double progress = 0.0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined,
                          color: CustomStyle.redDark),
                      const SizedBox(width: 8),
                      Text(l10n.signature_confirm_dialog_title(title),
                          style: CustomStyle.mediumTextBRed),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.signature_confirm_dialog_body_visit_report,
                      style: const TextStyle(color: CustomStyle.greyDark)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.slide_to_confirm,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: progress,
                                min: 0.0,
                                max: 1.0,
                                divisions: 20,
                                activeColor: CustomStyle.redDark,
                                onChanged: (v) {
                                  setState(() => progress = v);
                                  if (v >= 0.99) {
                                    Navigator.of(ctx).pop();
                                    context.read<ReportsBloc>().add(
                                          SignVisitReportRequested(
                                              visitReport: _visitReport),
                                        );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLinearStateDiagram() {
    final int stage = _currentStageIndex();
    final l10n = AppLocalizations.of(context)!;
    final List<String> labels = <String>[
      l10n.linear_stage_draft,
      l10n.linear_stage_employee_signed,
      l10n.linear_stage_client_signed
    ];

    Color dotColor(int idx) {
      if (idx <= stage) return Colors.green;
      return Colors.grey;
    }

    Color labelColor(int idx) {
      return dotColor(idx);
    }

    Color connectorColor(int idx) {
      if (idx < stage) return Colors.green;
      return Colors.grey;
    }

    Widget dot(int idx) => Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: dotColor(idx),
            shape: BoxShape.circle,
          ),
        );

    Widget connector(int idx) => Expanded(
          child: Container(
            height: 2,
            color: connectorColor(idx),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            dot(0),
            connector(0),
            dot(1),
            connector(1),
            dot(2),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (int i = 0; i < labels.length; i++)
              Expanded(
                flex: i == 1 ? 3 : 2,
                child: Text(
                  labels[i],
                  textAlign: i == 0
                      ? Directionality.of(context) == TextDirection.ltr
                          ? TextAlign.left
                          : TextAlign.right
                      : i == 2
                          ? Directionality.of(context) == TextDirection.ltr
                              ? TextAlign.right
                              : TextAlign.left
                          : TextAlign.center,
                  style: CustomStyle.smallText.copyWith(
                    color: labelColor(i),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  int _currentStageIndex() {
    if (_visitReport.employeeSignature.id == null) return 0; // Draft
    if (_visitReport.clientSignature.id == null) return 1; // Employee Signed
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.view_visit_report),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            if (state is ReportsAuthenticated) {
              if (state.message != null) {
                switch (state.message) {
                  case ReportsMessage.sharedWithUpdated:
                    state.message = null;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            l10n.contract_sharing_updated_success,
                            style: CustomStyle.smallTextBWhite),
                        backgroundColor: Colors.green,
                      ));
                    });
                    break;
                  case ReportsMessage.contractSigned:
                    state.message = null;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(l10n.contract_signed_success,
                            style: CustomStyle.smallTextBWhite),
                        backgroundColor: Colors.green,
                      ));
                    });
                    break;
                  case ReportsMessage.visitReportSigned:
                    state.message = null;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(l10n.visit_report_signed_success,
                            style: CustomStyle.smallTextBWhite),
                        backgroundColor: Colors.green,
                      ));
                    });
                    break;
                  default:
                    break;
                }
              }
              return _buildBody(state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildBody(ReportsAuthenticated state) {
    if (state.contracts == null ||
        state.contractItems == null ||
        state.user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    _user = state.user;
    _visitReport = state.visitReports!.firstWhere(
      (v) => v.id == widget.visitReportId,
    );
    _contract = state.contracts!.firstWhere(
      (c) => c.metaData.id == _visitReport.contractId,
    );
    return ListView(
      children: [
        _buildSignActionCard(context),
        const SizedBox(height: 16),
        _buildStateCard(context),
        const SizedBox(height: 16),
        VisitReportSummary(visitReport: _visitReport, index: 0),
        VisitReportDetails(visitReport: _visitReport, contract: _contract),
      ],
    );
  }
}
