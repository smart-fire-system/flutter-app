import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/helper.dart';
import 'package:fire_alarm_system/screens/reports/view/emergency_visits_screen.dart';
import 'package:fire_alarm_system/screens/reports/view/visit_reports_screen.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/cards.dart';
import 'package:flutter/material.dart';
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
  Set<String> _selectedSharedWith = {};

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
    final l10n = AppLocalizations.of(context)!;
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
      subtitle = l10n.contract_wait_employee_sign_subtitle;
    } else if (_isPendingOtherClientSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      title = l10n.contract_wait_other_client_sign_title;
      subtitle = l10n.contract_wait_other_client_sign_subtitle;
    } else if (_contract.metaData.state == ContractState.active) {
      if (!ContractsCommon.isContractExpired(_contract)) {
        cardColor = Colors.green.shade50;
        borderColor = Colors.greenAccent;
        title = l10n.contract_active_title;
        subtitle = l10n.contract_active_until(DateLocalizations.of(
            _contract.metaData.endDate,
            format: 'dd/MM/yyyy'));
      } else {
        cardColor = Colors.red.shade50;
        borderColor = CustomStyle.redLight;
        title = l10n.contract_expired_title;
        subtitle = l10n.contract_expired_since(DateLocalizations.of(
            _contract.metaData.endDate,
            format: 'dd/MM/yyyy'));
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
                      Text(
                        l10n.signature_confirm_dialog_title(title),
                        style: CustomStyle.mediumTextBRed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.signature_confirm_dialog_body,
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
    final l10n = AppLocalizations.of(context)!;
    final List<String> labels = <String>[
      l10n.linear_stage_draft,
      l10n.linear_stage_employee_signed,
      l10n.linear_stage_client_signed,
      ContractsCommon.isContractExpired(_contract)
          ? l10n.linear_stage_expired
          : l10n.linear_stage_active,
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

  void _showShareWithBottomSheet(BuildContext context,
      {required List<Employee> employees, required List<Client> clients}) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext ctx) {
        Set<String> tempSelected = {..._selectedSharedWith};
        return StatefulBuilder(
          builder: (context, setState) {
            Widget buildUserTile({
              required String id,
              required String name,
              required int code,
              required VoidCallback onTap,
            }) {
              final bool isSelected = tempSelected.contains(id);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?',
                    style: const TextStyle(color: CustomStyle.redDark),
                  ),
                ),
                title: Text(name),
                subtitle: Text('Code: $code'),
                trailing: Icon(
                  Icons.check,
                  color: isSelected ? Colors.green : Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      tempSelected.remove(id);
                    } else {
                      tempSelected.add(id);
                    }
                  });
                },
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.share, color: CustomStyle.redDark),
                        const SizedBox(width: 8),
                        Text(l10n.share_with,
                            style: CustomStyle.mediumTextBRed),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            context.read<ReportsBloc>().add(
                                  SharedWithUpdateRequested(
                                    contractId: widget.contractId,
                                    sharedWith: tempSelected.toList(),
                                  ),
                                );
                          },
                          child: Text(l10n.save_changes),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (clients.isNotEmpty) ...[
                            Text(l10n.clients,
                                style: CustomStyle.smallTextBRed),
                            const SizedBox(height: 6),
                            ...clients.map((c) => buildUserTile(
                                  id: c.info.id,
                                  name: c.info.name,
                                  code: c.info.code,
                                  onTap: () {},
                                )),
                            const SizedBox(height: 10),
                            const Divider(height: 1),
                            const SizedBox(height: 10),
                          ],
                          if (employees.isNotEmpty) ...[
                            Text(l10n.employees,
                                style: CustomStyle.smallTextBRed),
                            const SizedBox(height: 6),
                            ...employees.map((e) => buildUserTile(
                                  id: e.info.id,
                                  name: e.info.name,
                                  code: e.info.code,
                                  onTap: () {},
                                )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.view_contract,
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
                        content: Text(l10n.contract_sharing_updated_success,
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
    final l10n = AppLocalizations.of(context)!;
    if (state.contracts == null ||
        state.contractItems == null ||
        state.user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    _user = state.user;
    _contract = state.contracts!.firstWhere(
      (c) => c.metaData.id == widget.contractId,
    );
    _selectedSharedWith = _contract.sharedWith.map((e) => e.toString()).toSet();
    return ListView(
      children: [
        _buildSignActionCard(context),
        const SizedBox(height: 16),
        _buildStateCard(context),
        const SizedBox(height: 16),
        ContractSummary(contract: _contract, showViewContractButton: true),
        const SizedBox(height: 16),
        WideCard(
          icon: Icons.assignment,
          title: l10n.visit_reports,
          subtitle: l10n.visit_reports_subtitle,
          color: CustomStyle.redDark,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  VisitReportsScreen(contractId: widget.contractId),
            ),
          ),
        ),
        const SizedBox(height: 16),
        WideCard(
            icon: Icons.share,
            title: l10n.share_contract,
            subtitle: l10n.share_contract_subtitle,
            color: CustomStyle.redDark,
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
            onTap: () {
              _showShareWithBottomSheet(context,
                  employees: state.employees ?? const [],
                  clients: state.clients ?? const []);
            }),
        const SizedBox(height: 16),
        WideCard(
          icon: Icons.emergency,
          title: l10n.emergency_visits,
          subtitle: l10n.emergency_visits_subtitle,
          color: CustomStyle.redDark,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  EmergencyVisitsScreen(contractId: widget.contractId),
            ),
          ),
        ),
      ],
    );
  }
}
