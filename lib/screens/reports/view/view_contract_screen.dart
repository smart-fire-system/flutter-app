import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/reports/view/view.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/models/contract_data.dart';

class ViewContractScreen extends StatefulWidget {
  final String contractId;

  const ViewContractScreen({
    super.key,
    required this.contractId,
  });

  @override
  State<ViewContractScreen> createState() => _ViewContractScreenState();
}

class _ViewContractScreenState extends State<ViewContractScreen> {
  late ContractData _contract;
  late dynamic _user;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _stateLabel(ContractState? state) {
    switch (state) {
      case ContractState.active:
        if (_isContractExpired()) {
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

  Color _stateColor(ContractState? state) {
    switch (state) {
      case ContractState.active:
        if (_isContractExpired()) {
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

  Widget _buildContractInfoCard(BuildContext context) {
    return Card(
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
                    (_contract.paramContractNumber?.isNotEmpty == true)
                        ? S.of(context).contract_number_prefix(
                            _contract.paramContractNumber!)
                        : (_contract.metaData.code != null
                            ? S.of(context).contract_number_prefix(
                                _contract.metaData.code.toString())
                            : S.of(context).contract_label),
                    style: CustomStyle.mediumTextBRed,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _stateColor(_contract.metaData.state)
                        .withValues(alpha: 0.1),
                    border: Border.all(
                      color: _stateColor(_contract.metaData.state),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _stateLabel(_contract.metaData.state),
                    style: CustomStyle.smallTextB.copyWith(
                      color: _stateColor(_contract.metaData.state),
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
                        text: _formatDate(_contract.metaData.startDate),
                        style: CustomStyle.smallText,
                      ),
                      TextSpan(
                        text: S.of(context).period_to,
                        style: CustomStyle.smallTextBRed,
                      ),
                      TextSpan(
                        text: _formatDate(_contract.metaData.endDate),
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
                          text: _contract.metaData.employee?.info.name ?? '-',
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
                          text: _contract.metaData.client?.info.name ?? '-',
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
                          text: _contract.metaData.employee?.branch.name ?? '-',
                          style: CustomStyle.smallText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ContractDetailsScreen(contractId: widget.contractId),
                  ),
                ),
                icon: const Icon(Icons.visibility),
                label: Text(S.of(context).view_contract),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    Color iconColor =
        isEmployeeDraft ? CustomStyle.redDark : CustomStyle.greyDark;
    String title =
        isEmployeeDraft ? 'توقيع الموظف مطلوب أولاً' : 'بانتظار توقيع العميل';
    String subtitle = isEmployeeDraft
        ? 'يجب أن تقوم بالتوقيع أولاً ليتمكّن العميل من التوقيع. اضغط للتوقيع.'
        : 'تم توقيع الموظف. الرجاء إرسال الرابط للعميل أو تذكيره بالتوقيع.';
    if (_isPendingCurrentEmployeeSign()) {
      cardColor = Colors.red.shade50;
      borderColor = CustomStyle.redLight;
      iconColor = CustomStyle.redDark;
      title = 'توقيع الموظف مطلوب أولاً';
      subtitle =
          'يجب أن تقوم بالتوقيع أولاً ليتمكّن العميل من التوقيع. اضغط للتوقيع.';
    } else if (_isPendingOtherEmployeeSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      iconColor = Colors.orange;
      title = 'بانتظار توقيع الموظف';
      subtitle = 'بانتظار توقيع الموظف لكي يتمكن العميل من التوقيع.';
    } else if (_isPendingCurrentClientSign()) {
      cardColor = Colors.red.shade50;
      borderColor = CustomStyle.redLight;
      iconColor = CustomStyle.redDark;
      title = 'توقيع العميل مطلوب أولاً';
      subtitle = S.of(context).contract_wait_employee_sign_subtitle;
    } else if (_isPendingOtherClientSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      iconColor = Colors.orange;
      title = S.of(context).contract_wait_other_client_sign_title;
      subtitle = S.of(context).contract_wait_other_client_sign_subtitle;
    } else if (_contract.metaData.state == ContractState.active) {
      if (!_isContractExpired()) {
        cardColor = Colors.green.shade50;
        borderColor = Colors.greenAccent;
        iconColor = Colors.green;
        title = S.of(context).contract_active_title;
        subtitle = S
            .of(context)
            .contract_active_until(_formatDate(_contract.metaData.endDate));
      } else {
        cardColor = Colors.red.shade50;
        borderColor = CustomStyle.redLight;
        iconColor = CustomStyle.redDark;
        title = S.of(context).contract_expired_title;
        subtitle = S
            .of(context)
            .contract_expired_since(_formatDate(_contract.metaData.endDate));
      }
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(isEmployeeDraft
                    ? S.of(context).snackbar_signing_not_enabled
                    : S.of(context).snackbar_client_notification_not_enabled)),
          );
        },
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
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: CustomStyle.greyDark),
                    ),
                    const SizedBox(height: 10),
                    _buildLinearStateDiagram(),
                  ],
                ),
              ),
            ],
          ),
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
      _isContractExpired()
          ? S.of(context).linear_stage_expired
          : S.of(context).linear_stage_active,
    ];

    Color dotColor(int idx) {
      if (_isContractExpired() && idx == 3) return CustomStyle.redDark;
      if (idx <= stage) return Colors.green;
      return Colors.grey;
    }

    Color labelColor(int idx) {
      if (_isContractExpired() && idx == 3) return CustomStyle.redDark;
      return dotColor(idx);
    }

    Color connectorColor(int idx) {
      if (idx < stage) return Colors.green;
      if (_isContractExpired() && idx == 2) return CustomStyle.redDark;
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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: i == stage ? FontWeight.w700 : FontWeight.w500,
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

  bool _isContractExpired() {
    if (_contract.metaData.state == ContractState.active) {
      final DateTime today = DateTime.now();
      final DateTime? end = _contract.metaData.endDate;
      if (end != null &&
          !end.isBefore(DateTime(today.year, today.month, today.day))) {
        return false;
      } else {
        return true;
      }
    }
    // For non-active states, we still show the last node label based on end date if present
    final DateTime today2 = DateTime.now();
    final DateTime? end2 = _contract.metaData.endDate;
    if (end2 != null &&
        !end2.isBefore(DateTime(today2.year, today2.month, today2.day))) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: (_contract.paramContractNumber?.isNotEmpty == true)
            ? S
                .of(context)
                .contract_number_prefix(_contract.paramContractNumber!)
            : (_contract.metaData.code != null
                ? S
                    .of(context)
                    .contract_number_prefix(_contract.metaData.code.toString())
                : S.of(context).contract_label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            if (state is ReportsAuthenticated) {
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
    _contract = state.contracts!.firstWhere(
      (c) => c.metaData.id == widget.contractId,
    );
    return ListView(
      children: [
        _buildSignActionCard(context),
        const SizedBox(height: 16),
        _buildStateCard(context),
        const SizedBox(height: 16),
        _buildContractInfoCard(context),
        const SizedBox(height: 16),
        WideCard(
          icon: Icons.article,
          title: S.of(context).new_visit_report,
          subtitle: S.of(context).new_visit_report_subtitle,
          color: CustomStyle.redDark,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ContractDetailsScreen(contractId: widget.contractId),
            ),
          ),
        ),
        const SizedBox(height: 16),
        WideCard(
          icon: Icons.article,
          title: S.of(context).visit_reports,
          subtitle: S.of(context).visit_reports_subtitle,
          color: CustomStyle.redDark,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ContractDetailsScreen(contractId: widget.contractId),
            ),
          ),
        ),
        const SizedBox(height: 16),
        WideCard(
          icon: Icons.article,
          title: S.of(context).emergency_visit_request,
          subtitle: S.of(context).emergency_visit_request_subtitle,
          color: CustomStyle.redDark,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ContractDetailsScreen(contractId: widget.contractId),
            ),
          ),
        ),
      ],
    );
  }
}
