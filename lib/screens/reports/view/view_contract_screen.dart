import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/reports/view/common.dart';
import 'package:fire_alarm_system/screens/reports/view/components_builder.dart';
import 'package:fire_alarm_system/screens/reports/view/export_pdf.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  late List<ContractItem> _contractItems;

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
                      (_contract.paramContractNumber?.isNotEmpty == true)
                          ? 'عقد رقم: ${_contract.paramContractNumber}'
                          : (_contract.metaData.code != null
                              ? 'عقد رقم: ${_contract.metaData.code}'
                              : 'عقد'),
                      style: CustomStyle.mediumTextBRed,
                      textAlign: TextAlign.right,
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
                          text: 'ساري من ',
                          style: CustomStyle.smallTextBRed,
                        ),
                        TextSpan(
                          text: _formatDate(_contract.metaData.startDate),
                          style: CustomStyle.smallText,
                        ),
                        TextSpan(
                          text: ' إلى ',
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
                            text: 'الموظف: ',
                            style: CustomStyle.smallTextBRed,
                          ),
                          TextSpan(
                            text: _contract.metaData.employee?.info.name ?? '-',
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
                            text: _contract.metaData.client?.info.name ?? '-',
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
                                _contract.metaData.employee?.branch.name ?? '-',
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
      subtitle = 'يجب أن تقوم بالتوقيع أولاً ليكون العقد ساري. اضغط للتوقيع.';
    } else if (_isPendingOtherClientSign()) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orangeAccent;
      iconColor = Colors.orange;
      title = 'بانتظار توقيع العميل';
      subtitle = 'بانتظار توقيع العميل لكي يكون العقد ساري.';
    } else if (_contract.metaData.state == ContractState.active) {
      if (!_isContractExpired()) {
        cardColor = Colors.green.shade50;
        borderColor = Colors.greenAccent;
        iconColor = Colors.green;
        title = 'العقد ساري';
        subtitle = 'العقد ساري حتى ${_formatDate(_contract.metaData.endDate)}';
      } else {
        cardColor = Colors.red.shade50;
        borderColor = CustomStyle.redLight;
        iconColor = CustomStyle.redDark;
        title = 'العقد منتهي';
        subtitle = 'العقد منتهي منذ ${_formatDate(_contract.metaData.endDate)}';
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
          ),
        );
      },
    );
  }

  Widget _buildLinearStateDiagram() {
    final int stage = _currentStageIndex();
    final List<String> labels = <String>[
      'مسودة',
      'توقيع الموظف',
      'توقيع العميل',
      _isContractExpired() ? 'منتهي' : 'ساري',
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
                      ? TextAlign.right
                      : i == 3
                          ? TextAlign.left
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

  Widget _buildSignatureBox({
    required String title,
    required String subtitle,
    SignatureData? signature,
    String? signatureUrl,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.right,
              style: CustomStyle.smallTextBRed,
            ),
            const SizedBox(height: 8),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: CustomStyle.smallText,
              ),
            ),
            const SizedBox(height: 8),
            if (signature != null && signature.name != null) ...[
              Center(
                child: GestureDetector(
                  onTap: () => _showSignatureInfoDialog(
                      context, title, subtitle, signature,
                      signatureUrl: signatureUrl),
                  child: QrImageView(
                    data: signature.name ?? '',
                    version: QrVersions.auto,
                    size: 100,
                  ),
                ),
              ),
              Text(
                signature.name ?? '',
                textAlign: TextAlign.center,
                style: CustomStyle.smallText,
              ),
              if (signatureUrl != null)
                Image.network(signatureUrl, height: 100),
            ]
          ],
        ),
      ),
    );
  }

  void _showSignatureInfoDialog(BuildContext context, String title,
      String subtitle, SignatureData signature,
      {String? signatureUrl}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(title, style: CustomStyle.mediumTextBRed),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(subtitle, style: CustomStyle.smallText),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: QrImageView(
                          data: signature.name ?? '',
                          version: QrVersions.auto,
                        ),
                      ),
                      if (signatureUrl != null)
                        Image.network(signatureUrl, height: 100),
                    ],
                  ),
                  Table(
                    border:
                        TableBorder.all(color: Colors.grey.shade300, width: 1),
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('كود التوقيع',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(signature.name?.toString() ?? '-',
                              style: CustomStyle.smallText,
                              textAlign: TextAlign.right),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('تاريخ التوقيع',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            (() {
                              final v = signature.createdAt?.toDate();
                              if (v == null) return '-';
                              return _formatDate(v);
                            })(),
                            style: CustomStyle.smallText,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('اسم المستخدم',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(signature.user?.name ?? '-',
                              style: CustomStyle.smallText,
                              textAlign: TextAlign.right),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('كود المستخدم',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(signature.user?.code.toString() ?? '-',
                              style: CustomStyle.smallText,
                              textAlign: TextAlign.right),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignaturesSection(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSignatureBox(
                    title: 'الطرف الأول',
                    subtitle: _contract.metaData.employee?.branch
                            .contractFirstParty?.name ??
                        '',
                    signature: _contract.metaData.employeeSignature,
                    signatureUrl: _contract.metaData.employee?.branch
                        .contractFirstParty?.signatureUrl,
                  ),
                  const SizedBox(width: 12),
                  _buildSignatureBox(
                    title: 'الطرف الثاني',
                    subtitle: _contract.metaData.client?.info.name ?? '',
                    signature: _contract.metaData.clientSignature,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Report'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => ExportPdf().contract(
              context: context,
              items: _contractItems,
              contract: _contract,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              if (state is ReportsAuthenticated) {
                return _buildBody(state);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
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
    _contractItems = state.contractItems!;
    _contract = state.contracts!.firstWhere(
      (c) => c.metaData.id == widget.contractId,
    );
    return ListView.separated(
      itemBuilder: (context, idx) {
        // Build dynamic header stack (single unified state card)
        final List<Widget> header = [];
        header.add(_buildSignActionCard(context));
        header.add(_buildStateCard(context));
        header.add(_buildContractInfoCard(context));

        if (idx < header.length) {
          return header[idx];
        }
        final int afterHeaderIdx = idx - header.length;
        // Items range
        if (afterHeaderIdx < _contractItems.length) {
          final item = _contractItems[afterHeaderIdx];
          if (item.text != null) {
            // Skip category title if next table has no selected types (from contract)
            if (ContractsCommon().isCategoryTitle(item.text!) &&
                afterHeaderIdx + 1 < _contractItems.length) {
              final table = _contractItems[afterHeaderIdx + 1].category;
              final hasAny = ContractsCommon()
                  .typesForCategory(_contract, table?.categoryIndex)
                  .isNotEmpty;
              if (!hasAny) return const SizedBox.shrink();
            }
            final text =
                ContractsCommon().renderTemplate(_contract, item.text!);
            TextStyle style =
                const TextStyle(fontFamily: 'Arial', fontSize: 16);
            if (item.text!.bold == true) {
              style = style.copyWith(fontWeight: FontWeight.bold);
            }
            if (item.text!.underlined == true) {
              style = style.copyWith(decoration: TextDecoration.underline);
            }
            if (item.text!.color != null) {
              style = style.copyWith(color: item.text!.color);
            }
            return Container(
              color: item.text!.backgroundColor,
              width: double.infinity,
              child: Text(
                text,
                style: style,
                textAlign: item.text!.align,
              ),
            );
          }
          return const SizedBox.shrink();
        }
        if (afterHeaderIdx == _contractItems.length) {
          return ComponentsBuilder(
            componentsData: _contract.componentsData,
            showOnly: true,
            onChange: (componentsData) {
              _contract.componentsData = componentsData;
            },
          );
        }
        // After items: show signatures section
        return _buildSignaturesSection(context);
      },
      itemCount: () {
        return 4 + _contractItems.length + 1; // 3 headers + items + signatures
      }(),
      separatorBuilder: (context, idx) {
        // Add spacing between header blocks and items
        return const SizedBox(height: 16);
      },
    );
  }
}
