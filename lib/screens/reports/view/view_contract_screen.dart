import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/contract_data.dart';

class ViewContractScreen extends StatefulWidget {
  final List<dynamic> items;
  final ContractData contract;
  final dynamic user;

  const ViewContractScreen({
    super.key,
    required this.items,
    required this.contract,
    required this.user,
  });

  @override
  State<ViewContractScreen> createState() => _ViewContractScreenState();
}

class _ViewContractScreenState extends State<ViewContractScreen> {
  late List<dynamic> items;
  late ContractData contract;
  late dynamic user;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    contract = widget.contract;
    user = widget.user;
  }

  String _paramText(String key) {
    switch (key) {
      case 'paramContractNumber':
        return contract.paramContractNumber ?? '';
      case 'paramContractAgreementDay':
        return contract.paramContractAgreementDay ?? '';
      case 'paramContractAgreementHijriDate':
        return contract.paramContractAgreementHijriDate ?? '';
      case 'paramContractAgreementGregorianDate':
        return contract.paramContractAgreementGregorianDate ?? '';
      case 'paramFirstPartyName':
        return contract.paramFirstPartyName ?? '';
      case 'paramFirstPartyCommNumber':
        return contract.paramFirstPartyCommNumber ?? '';
      case 'paramFirstPartyAddress':
        return contract.paramFirstPartyAddress ?? '';
      case 'paramFirstPartyRep':
        return contract.paramFirstPartyRep ?? '';
      case 'paramFirstPartyRepIdNumber':
        return contract.paramFirstPartyRepIdNumber ?? '';
      case 'paramFirstPartyG':
        return contract.paramFirstPartyG ?? '';
      case 'paramSecondPartyName':
        return contract.paramSecondPartyName ?? '';
      case 'paramSecondPartyCommNumber':
        return contract.paramSecondPartyCommNumber ?? '';
      case 'paramSecondPartyAddress':
        return contract.paramSecondPartyAddress ?? '';
      case 'paramSecondPartyRep':
        return contract.paramSecondPartyRep ?? '';
      case 'paramSecondPartyRepIdNumber':
        return contract.paramSecondPartyRepIdNumber ?? '';
      case 'paramSecondPartyG':
        return contract.paramSecondPartyG ?? '';
      case 'paramContractAddDate':
        return contract.paramContractAddDate ?? '';
      case 'paramContractPeriod':
        return contract.paramContractPeriod ?? '';
      case 'paramContractAmount':
        return contract.paramContractAmount ?? '';
      default:
        return '';
    }
  }

  String _renderTemplate(ReportTextItem item) {
    String result = item.templateValue;
    if (item.parameters != null) {
      item.parameters!.forEach((key, type) {
        final text = _paramText(key);
        result = result.replaceAll('{{$key}}', text);
      });
    }
    return result;
  }

  bool _isCategoryTitle(ReportTextItem item) {
    final t = item.templateValue.trim();
    return t.startsWith('• ');
  }

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
        return 'ساري';
      case ContractState.pendingClient:
        return 'بانتظار العميل';
      case ContractState.requestCancellation:
        return 'طلب إلغاء';
      case ContractState.expired:
        return 'منتهي';
      case ContractState.cancelled:
        return 'ملغي';
      case ContractState.draft:
      default:
        return 'مسودة';
    }
  }

  Color _stateColor(ContractState? state) {
    switch (state) {
      case ContractState.active:
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
    return Directionality(
      textDirection: TextDirection.rtl,
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
                      (contract.paramContractNumber?.isNotEmpty == true)
                          ? 'عقد رقم: ${contract.paramContractNumber}'
                          : (contract.metaData.code != null
                              ? 'عقد رقم: ${contract.metaData.code}'
                              : 'عقد'),
                      style: CustomStyle.mediumTextBRed,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _stateColor(contract.metaData.state)
                          .withValues(alpha: 0.1),
                      border: Border.all(
                        color: _stateColor(contract.metaData.state),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _stateLabel(contract.metaData.state),
                      style: CustomStyle.smallTextB.copyWith(
                        color: _stateColor(contract.metaData.state),
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
                          text: 'ساري من ',
                          style: CustomStyle.smallTextBRed,
                        ),
                        TextSpan(
                          text: _formatDate(contract.metaData.startDate),
                          style: CustomStyle.smallText,
                        ),
                        TextSpan(
                          text: ' إلى ',
                          style: CustomStyle.smallTextBRed,
                        ),
                        TextSpan(
                          text: _formatDate(contract.metaData.endDate),
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
                            text: 'الموظف: ',
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: contract.metaData.employee?.info.name ?? '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
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
                            text: 'العميل: ',
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: contract.metaData.client?.info.name ?? '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
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
                            text: 'الفرع: ',
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text:
                                contract.metaData.employee?.branch.name ?? '-',
                            style: CustomStyle.smallText,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
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

  bool _isPendingCurrentEmployeeSign() {
    if (user is! Employee) return false;
    final String currentId = (user as Employee).info.id;
    final String? contractEmpId = contract.metaData.employee?.info.id;
    return contract.metaData.state == ContractState.draft &&
        contractEmpId != null &&
        contractEmpId == currentId;
  }

  bool _isPendingOtherEmployeeSign() {
    return contract.metaData.state == ContractState.draft;
  }

  bool _isPendingCurrentClientSign() {
    if (user is! Client) return false;
    final String currentId = (user as Client).info.id;
    final String? contractClientId = contract.metaData.client?.info.id;
    return contract.metaData.state == ContractState.pendingClient &&
        contractClientId != null &&
        contractClientId == currentId;
  }

  bool _isPendingOtherClientSign() {
    return contract.metaData.state == ContractState.pendingClient;
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
      subtitle = 'يجب أن تقوم بالتوقيع أولاً ليكون العقد ساري. اضغط للتوقيع.';
    } else if (_isPendingOtherClientSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      iconColor = Colors.orange;
      title = 'بانتظار توقيع العميل';
      subtitle = 'بانتظار توقيع العميل لكي يكون العقد ساري.';
    } else if (contract.metaData.state == ContractState.active) {
      final DateTime today = DateTime.now();
      final DateTime? end = contract.metaData.endDate;
      if (end != null &&
          !end.isBefore(DateTime(today.year, today.month, today.day))) {
        cardColor = Colors.green.shade50;
        borderColor = Colors.greenAccent;
        iconColor = Colors.green;
        title = 'العقد ساري';
        subtitle = 'العقد ساري حتى ${_formatDate(end)}';
      } else {
        cardColor = Colors.red.shade50;
        borderColor = CustomStyle.redLight;
        iconColor = CustomStyle.redDark;
        title = 'العقد منتهي';
        subtitle = 'العقد منتهي منذ ${_formatDate(end)}';
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
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
                      ? 'التوقيع غير مفعّل بعد'
                      : 'تنبيه العميل غير مفعّل بعد')),
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
      ),
    );
  }

  Widget _buildSignActionCard(BuildContext context) {
    final bool canEmployeeSign = _isPendingCurrentEmployeeSign();
    final bool canClientSign = _isPendingCurrentClientSign();
    if (!canEmployeeSign && !canClientSign) return const SizedBox.shrink();

    final String title = canEmployeeSign ? 'توقيع الموظف' : 'توقيع العميل';
    const String subtitle = 'اضغط للتأكيد ثم اسحب شريط التأكيد لإتمام التوقيع.';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
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
                  child: const Icon(Icons.edit_document,
                      color: CustomStyle.redDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: CustomStyle.mediumTextBRed,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      const Text(subtitle,
                          style: TextStyle(color: CustomStyle.greyDark),
                          textAlign: TextAlign.right),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_left,
                    color: CustomStyle.greyDark),
              ],
            ),
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
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
                          'تأكيد $title',
                          style: CustomStyle.mediumTextBRed,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'بتأكيدك سيتم تسجيل توقيعك على هذا العقد. لا يمكن التراجع عن هذه العملية.',
                      style: TextStyle(color: CustomStyle.greyDark),
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
                          const Text(
                            'اسحب للتأكيد',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
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
                                                contract: contract),
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
          ),
        );
      },
    );
  }

  // Build linear diagram: Draft -> Employee Signed -> Client Signed -> Active/Expired
  Widget _buildLinearStateDiagram() {
    final int stage = _currentStageIndex();
    final String lastLabel = _finalStageLabel();
    final List<String> labels = <String>[
      'مسودة',
      'توقيع الموظف',
      'توقيع العميل',
      lastLabel,
    ];

    Color stepColor(int idx) {
      if (idx < stage) return Colors.green; // completed
      if (idx == stage) return CustomStyle.redDark; // current
      return Colors.grey; // pending
    }

    Widget dot(int idx) => Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: stepColor(idx),
            shape: BoxShape.circle,
          ),
        );

    Widget connector(int idx) => Expanded(
          child: Container(
            height: 2,
            color: stepColor(idx),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                child: Center(
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          i == stage ? FontWeight.w700 : FontWeight.w500,
                      color: stepColor(i),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  int _currentStageIndex() {
    final ContractState? s = contract.metaData.state;
    if (s == ContractState.draft) return 0; // Draft
    if (s == ContractState.pendingClient) return 1; // Employee Signed
    // active: client signed, then Active/Expired based on end date
    if (s == ContractState.active) {
      // Stage index for Active/Expired is 3 (last)
      return 3;
    }
    // Fallback
    return 0;
  }

  String _finalStageLabel() {
    if (contract.metaData.state == ContractState.active) {
      final DateTime today = DateTime.now();
      final DateTime? end = contract.metaData.endDate;
      if (end != null &&
          !end.isBefore(DateTime(today.year, today.month, today.day))) {
        return 'ساري';
      } else {
        return 'منتهي';
      }
    }
    // For non-active states, we still show the last node label based on end date if present
    final DateTime today2 = DateTime.now();
    final DateTime? end2 = contract.metaData.endDate;
    if (end2 != null &&
        !end2.isBefore(DateTime(today2.year, today2.month, today2.day))) {
      return 'ساري';
    }
    return 'منتهي';
  }

  List<String> _typesForCategory(int? categoryIndex) {
    if (categoryIndex == null) return const [];
    final List<String> names = [];
    for (final cat in contract.components) {
      for (final item in cat.items) {
        if (item.categoryIndex == categoryIndex) {
          final String name = (item.arName.trim().isNotEmpty
                  ? item.arName.trim()
                  : item.enName.trim())
              .trim();
          if (!names.contains(name)) names.add(name);
        }
      }
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocListener<ReportsBloc, ReportsState>(
            listener: (context, state) {
              if (state is ReportsSigned) {
                setState(() {
                  contract = state.contract;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم التوقيع بنجاح')),
                );
              }
            },
            child: ListView.separated(
              itemBuilder: (context, idx) {
                // Build dynamic header stack (single unified state card)
                final List<Widget> header = [];
                header.add(_buildSignActionCard(context));
                header.add(_buildStateCard(context));
                header.add(_buildContractInfoCard(context));

                if (idx < header.length) {
                  return header[idx];
                }
                final realIdx = idx - header.length;
                final item = items[realIdx];
                if (item.text != null) {
                  // Skip category title if next table has no selected types (from contract)
                  if (_isCategoryTitle(item.text) &&
                      realIdx + 1 < items.length) {
                    final table = items[realIdx + 1]?.table;
                    final hasAny =
                        _typesForCategory(table?.categoryIndex).isNotEmpty;
                    if (!hasAny) return const SizedBox.shrink();
                  }
                  final text = _renderTemplate(item.text);
                  TextStyle style =
                      const TextStyle(fontFamily: 'Arial', fontSize: 16);
                  if (item.text.bold == true) {
                    style = style.copyWith(fontWeight: FontWeight.bold);
                  }
                  if (item.text.underlined == true) {
                    style =
                        style.copyWith(decoration: TextDecoration.underline);
                  }
                  if (item.text.color != null) {
                    style = style.copyWith(color: item.text.color);
                  }
                  return Container(
                    color: item.text.backgroundColor,
                    width: double.infinity,
                    child: Text(
                      text,
                      style: style,
                      textAlign: item.text.align,
                    ),
                  );
                } else if (item.table != null) {
                  final table = item.table;
                  final types = _typesForCategory(table.categoryIndex);
                  if (types.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          border: TableBorder.all(
                              color: Colors.grey.shade300, width: 1),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(
                                color: CustomStyle.greyDark,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  child: Text('النوع',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  child: Text('العدد',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  child: Text('ملاحظات',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                            ...types.asMap().entries.map((entry) {
                              final i = entry.key;
                              final type = entry.value;
                              final isEven = i % 2 == 0;
                              final details = contract.componentDetails[
                                          table.categoryIndex?.toString() ?? '']
                                      ?[type] ??
                                  const {};
                              final quantity = details['quantity'] ?? '';
                              final notes = details['notes'] ?? '';
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: isEven
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child:
                                        Text(type, textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Text(quantity,
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Text(notes,
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              itemCount: () {
                return 2 + items.length; // state + info + items
              }(),
              separatorBuilder: (context, idx) {
                // Add spacing between header blocks and items
                return const SizedBox(height: 16);
              },
            ),
          ),
        ),
      ),
    );
  }
}
