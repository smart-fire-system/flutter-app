import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/helper.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:jhijri/jHijri.dart';
import 'package:jhijri_picker/jhijri_picker.dart';

class NewVisitReportScreen extends StatefulWidget {
  final String contractId;
  const NewVisitReportScreen({super.key, required this.contractId});

  @override
  State<NewVisitReportScreen> createState() => _NewVisitReportScreenState();
}

class _NewVisitReportScreenState extends State<NewVisitReportScreen> {
  List<ContractData> _contracts = [];
  ContractData? _contract;
  Employee? _employee;
  List<ContractComponent> _contractComponents = [];
  List<ContractCategory> _contractCategories = [];
  ContractComponents _componentsData = ContractComponents();
  late JHijri _visitDateHijri;
  final VisitReportData _visitReportData = VisitReportData();
  late final TextEditingController _clientNameController;
  late final TextEditingController _clientController;
  late final TextEditingController _clientAddressController;
  late final TextEditingController _contractNumberController;
  late final TextEditingController _visitDateController;
  late final TextEditingController _systemStatusController;
  late final TextEditingController _contractController;
  late final TextEditingController _notesController;
  int _systemStatusValue = 2;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _clientAddressController = TextEditingController();
    _contractNumberController = TextEditingController();
    _visitDateController = TextEditingController();
    _systemStatusController = TextEditingController();
    _clientController = TextEditingController();
    _contractController = TextEditingController();
    _notesController = TextEditingController();
    _visitDateHijri = JHijri.now();
    _visitDateController.text = _visitDateHijri.toString();
  }

  Widget _buildMergedTable() {
    Color borderColor = Colors.grey.shade300;

    Widget cell(
        {Widget? child,
        bool top = true,
        bool right = true,
        bool bottom = true,
        bool left = true}) {
      return Container(
        constraints: const BoxConstraints(minHeight: 48),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            right: right
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            bottom: bottom
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            left: left
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: child == null
            ? const SizedBox.shrink()
            : SizedBox(width: double.infinity, child: child),
      );
    }

    List<Widget> rows = [];

    Map<String, dynamic> getTextAndController(int row) {
      switch (row) {
        case 2:
          return {
            'text': 'اسم العميل\nClient Name',
            'controller': _clientNameController
          };
        case 3:
          return {
            'text': 'عنوان العميل\nClient Address',
            'controller': _clientAddressController
          };
        case 4:
          return {
            'text': 'رقم العقد\nContract Number',
            'controller': _contractNumberController
          };
        case 5:
          return {
            'text': 'تاريخ الزيارة\nVisit Date',
            'controller': _visitDateController
          };
        case 6:
          return {
            'text': 'حالة النظام\nSystem Status',
            'controller': _systemStatusController
          };
        default:
          return {'text': '', 'controller': null};
      }
    }

    rows.add(Row(
      children: [
        Expanded(
          flex: 2,
          child: cell(
            child: const Center(
              child: Text(
                'تقرير عن حالة انظمة انذار واطفاء الحريق',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            top: true,
            bottom: false,
            left: true,
            right: true,
          ),
        ),
      ],
    ));

    rows.add(Row(
      children: [
        Expanded(
          flex: 2,
          child: cell(
            child: const Center(
              child: Text(
                'Fire Alarm & Fire Fighting Systems Maintenance Report',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            top: true,
            bottom: false,
            left: true,
            right: true,
          ),
        ),
      ],
    ));

    for (int r = 2; r < 7; r++) {
      final bool isLast = r == 6;
      final Map<String, dynamic> textAndController = getTextAndController(r);
      rows.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: borderColor, width: 1),
              bottom: isLast
                  ? BorderSide(color: borderColor, width: 1)
                  : BorderSide.none,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: cell(
                    child: Text(textAndController['text'],
                        textAlign: TextAlign.center),
                    top: false,
                    bottom: false,
                    left: false,
                    right: true,
                  ),
                ),
                Expanded(
                  child: cell(
                    child: TextField(
                      controller: textAndController['controller'],
                      onTap: r != 5
                          ? null
                          : () async {
                              JPickerValue? picked = await showGlobalDatePicker(
                                context: context,
                                pickerType: PickerType.JHijri,
                                selectedDate:
                                    JDateModel(jhijri: _visitDateHijri),
                              );
                              if (picked != null) {
                                setState(() {
                                  _visitDateHijri = picked.jhijri;
                                  _visitDateController.text =
                                      _visitDateHijri.toString();
                                });
                              }
                            },
                      readOnly: r == 5,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.5),
                        ),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    top: false,
                    bottom: false,
                    left: true,
                    right: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: rows,
        ),
      ),
    );
  }

  Widget _buildResult() {
    Color borderColor = Colors.grey.shade300;

    Widget cell(
        {Widget? child,
        bool top = true,
        bool right = true,
        bool bottom = true,
        bool left = true}) {
      return Container(
        constraints: const BoxConstraints(minHeight: 48),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            right: right
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            bottom: bottom
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            left: left
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: child == null
            ? const SizedBox.shrink()
            : SizedBox(width: double.infinity, child: child),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                  bottom: BorderSide.none,
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: cell(
                        child: const Text('حالة الأنظمة\nSystem Status',
                            textAlign: TextAlign.center),
                        top: false,
                        bottom: false,
                        left: false,
                        right: true,
                      ),
                    ),
                    Expanded(
                      child: cell(
                        child: Column(
                          children: [
                            Expanded(
                              child: RadioGroup(
                                groupValue: _systemStatusValue,
                                onChanged: (val) {
                                  setState(() {
                                    _systemStatusValue = val ?? 0;
                                  });
                                },
                                child: const RadioListTile<int>(
                                  dense: true,
                                  value: 1,
                                  title: Text('ملائم - Suitable'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: RadioGroup(
                                groupValue: _systemStatusValue,
                                onChanged: (val) {
                                  setState(() {
                                    _systemStatusValue = val ?? 0;
                                  });
                                },
                                child: const RadioListTile<int>(
                                  dense: true,
                                  value: 0,
                                  title: Text('غير ملائم - Unsuitable'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        top: false,
                        bottom: false,
                        left: true,
                        right: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: cell(
                        child: const Text('ملاحظات\nNotes',
                            textAlign: TextAlign.center),
                        top: false,
                        bottom: false,
                        left: false,
                        right: true,
                      ),
                    ),
                    Expanded(
                      child: cell(
                        child: TextField(
                          controller: _notesController,
                          textDirection: TextDirection.rtl,
                          minLines: 1,
                          maxLines: null,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 1.5),
                            ),
                          ),
                        ),
                        top: false,
                        bottom: false,
                        left: true,
                        right: true,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.reports),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsAuthenticated) {
            return _buildBody(state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildBody(ReportsAuthenticated state) {
    if (state.employees == null ||
        state.clients == null ||
        state.visitReports == null ||
        state.contractComponents == null ||
        state.contractCategories == null ||
        state.user == null ||
        state.user is! Employee) {
      return const Center(child: CircularProgressIndicator());
    }
    _employee = state.user;
    _contracts = state.contracts!;
    _contractComponents = state.contractComponents!;
    _contractCategories = state.contractCategories!;
    _contract =
        _contracts.firstWhere((c) => c.metaData.id == widget.contractId);
    _clientNameController.text = _contract?.paramSecondPartyName ?? '';
    _clientAddressController.text = _contract?.paramSecondPartyAddress ?? '';
    _contractNumberController.text =
        _contract?.paramContractNumber ?? _contract?.metaData.id ?? '';
    _componentsData = _contract?.componentsData ?? ContractComponents();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (ctx) {
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
                        const Text(
                          'معلومات تقرير الزيارة',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: _employee?.branch.name ?? 'غير محدد',
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'الفرع',
                            suffixIcon: Icon(Icons.corporate_fare),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: _employee?.info.name ?? 'غير محدد',
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'الموظف',
                            suffixIcon: Icon(Icons.person),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: _contract?.metaData.client?.info.name ??
                              'غير محدد',
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'العميل',
                            hintText: 'اختيار العميل',
                            suffixIcon: Icon(Icons.person),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          readOnly: true,
                          initialValue:
                              'عقد رقم: ${_contract?.paramContractNumber ?? 'غير محدد'}',
                          decoration: const InputDecoration(
                            labelText: 'العقد',
                            hintText: 'اختيار العقد',
                            suffixIcon: Icon(Icons.document_scanner),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              }),
              _buildMergedTable(),
              const SizedBox(height: 24),
              const Text(
                'ادارة السلامة في الدفاع المدني بمنطقة المدينة المنورة المحترمين',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Text(
                '•	قامت فرقة الصيانة بزيارة روتينية للموقع الخاص بالعميل والكشف الكامل على نظام الإنذار والإطفاء المكون من: -',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              ComponentsBuilder(
                components: _contractComponents,
                categories: _contractCategories,
                componentsData: _componentsData,
                onChange: (data) {
                  _componentsData = data;
                },
              ),
              const SizedBox(height: 16),
              _buildResult(),
              CustomNormalButton(
                label: 'حفظ التقرير',
                fullWidth: true,
                backgroundColor: Colors.green,
                onPressed: () {
                  _visitReportData.paramClientName = _clientNameController.text;
                  _visitReportData.paramClientAddress =
                      _clientAddressController.text;
                  _visitReportData.paramContractNumber =
                      _contractNumberController.text;
                  _visitReportData.paramVisitDate = _visitDateController.text;
                  _visitReportData.paramSystemStatus =
                      _systemStatusController.text;
                  _visitReportData.paramSystemStatusBool =
                      _systemStatusValue.toString();
                  _visitReportData.paramNotes = _notesController.text;
                  _visitReportData.componentsData = _componentsData;
                  _visitReportData.contractMetaData =
                      _contract?.metaData ?? ContractMetaData();
                  _visitReportData.contractId = widget.contractId;
                  _visitReportData.employeeId = _employee?.info.id;
                  context.read<ReportsBloc>().add(
                      SaveVisitReportRequested(visitReport: _visitReportData));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clientAddressController.dispose();
    _contractNumberController.dispose();
    _visitDateController.dispose();
    _systemStatusController.dispose();
    _clientController.dispose();
    _clientNameController.dispose();
    _contractController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
