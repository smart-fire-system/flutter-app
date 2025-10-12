import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/helper.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/visit_report_details.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/visit_report_summary.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
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
    final String currentId = (_user as Employee).info.id;
    final String? contractEmpId = _contract.metaData.employee?.info.id;
    return _contract.metaData.state == ContractState.draft &&
        contractEmpId != null &&
        contractEmpId == currentId;
  }

  bool _isPendingOtherEmployeeSign() {
    return _contract.metaData.state == ContractState.draft;
  }

  bool _isPendingCurrentClientSign() {
    if (_user is! Client) return false;
    final String currentId = (_user as Client).info.id;
    final String? contractClientId = _contract.metaData.client?.info.id;
    return _contract.metaData.state == ContractState.pendingClient &&
        contractClientId != null &&
        contractClientId == currentId;
  }

  bool _isPendingOtherClientSign() {
    return _contract.metaData.state == ContractState.pendingClient;
  }

  Widget _buildStateCard(BuildContext context) {
    bool isEmployeeDraft = _isPendingCurrentEmployeeSign();
    Color cardColor =
        isEmployeeDraft ? Colors.red.shade50 : Colors.blue.shade50;
    Color borderColor =
        isEmployeeDraft ? CustomStyle.redLight : CustomStyle.greyLight;
    String title = '';
    String subtitle = '';
    if (_isPendingCurrentEmployeeSign()) {
      cardColor = Colors.red.shade50;
      borderColor = CustomStyle.redLight;
      title = S.of(context).sign_employee_required_title;
      subtitle = S.of(context).sign_employee_required_subtitle;
    } else if (_isPendingOtherEmployeeSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      title = S.of(context).waiting_employee_signature_title;
      subtitle = S.of(context).waiting_employee_signature_subtitle;
    } else if (_isPendingCurrentClientSign()) {
      cardColor = Colors.red.shade50;
      borderColor = CustomStyle.redLight;
      title = S.of(context).sign_client_required_title;
      subtitle = S.of(context).contract_wait_employee_sign_subtitle;
    } else if (_isPendingOtherClientSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      title = S.of(context).contract_wait_other_client_sign_title;
      subtitle = S.of(context).contract_wait_other_client_sign_subtitle;
    } else if (_contract.metaData.state == ContractState.active) {
      if (!ContractsCommon.isContractExpired(_contract)) {
        cardColor = Colors.green.shade50;
        borderColor = Colors.greenAccent;
        title = S.of(context).contract_active_title;
        subtitle = 'fdff';
      } else {
        cardColor = Colors.red.shade50;
        borderColor = CustomStyle.redLight;
        title = S.of(context).contract_expired_title;
        subtitle = 'fdff';
      }
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
    final bool canEmployeeSign = _isPendingCurrentEmployeeSign();
    final bool canClientSign = _isPendingCurrentClientSign();
    if (!canEmployeeSign && !canClientSign) return const SizedBox.shrink();

    final String title = canEmployeeSign
        ? S.of(context).signature_employee_title
        : S.of(context).signature_client_title;
    final String subtitle = S.of(context).signature_confirm_dialog_body;

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
                      Text(
                        S.of(context).signature_confirm_dialog_title(title),
                        style: CustomStyle.mediumTextBRed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S.of(context).signature_confirm_dialog_body,
                    style: const TextStyle(color: CustomStyle.greyDark),
                  ),
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
                          S.of(context).slide_to_confirm,
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
                                          SignContractRequested(
                                              contract: _contract),
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
    final List<String> labels = <String>[
      S.of(context).linear_stage_draft,
      S.of(context).linear_stage_employee_signed,
      S.of(context).linear_stage_client_signed,
      ContractsCommon.isContractExpired(_contract)
          ? S.of(context).linear_stage_expired
          : S.of(context).linear_stage_active,
    ];

    Color dotColor(int idx) {
      if (ContractsCommon.isContractExpired(_contract) && idx == 3) {
        return CustomStyle.redDark;
      }
      if (idx <= stage) return Colors.green;
      return Colors.grey;
    }

    Color labelColor(int idx) {
      if (ContractsCommon.isContractExpired(_contract) && idx == 3) {
        return CustomStyle.redDark;
      }
      return dotColor(idx);
    }

    Color connectorColor(int idx) {
      if (idx < stage) return Colors.green;
      if (ContractsCommon.isContractExpired(_contract) && idx == 2) {
        return CustomStyle.redDark;
      }
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
            connector(2),
            dot(3),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (int i = 0; i < labels.length; i++)
              Expanded(
                flex: i == 0 || i == 3 ? 2 : 3,
                child: Text(
                  labels[i],
                  textAlign: i == 0
                      ? Directionality.of(context) == TextDirection.ltr
                          ? TextAlign.left
                          : TextAlign.right
                      : i == 3
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
    final ContractState? s = _contract.metaData.state;
    if (s == ContractState.draft) return 0; // Draft
    if (s == ContractState.pendingClient) return 1; // Employee Signed
    if (s == ContractState.active) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).view_contract,
      ),
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
                            S.of(context).contract_sharing_updated_success,
                            style: CustomStyle.smallTextBWhite),
                        backgroundColor: Colors.green,
                      ));
                    });
                    break;
                  case ReportsMessage.contractSigned:
                    state.message = null;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(S.of(context).contract_signed_success,
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
        const SizedBox(height: 16),
        VisitReportDetails(visitReport: _visitReport, contract: _contract),
      ],
    );
  }
}
