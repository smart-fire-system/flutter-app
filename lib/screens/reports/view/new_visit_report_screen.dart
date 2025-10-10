import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/screens/reports/view/components_builder.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
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
  const NewVisitReportScreen({super.key});

  @override
  State<NewVisitReportScreen> createState() => _NewVisitReportScreenState();
}

class _NewVisitReportScreenState extends State<NewVisitReportScreen> {
  List<Client> _clients = [];
  List<ContractData> _contracts = [];
  Client? _selectedClient;
  ContractData? _selectedContract;
  //VisitReportData? _visitReportData;
  Employee? _employee;
  List<ContractComponent> _contractComponents = [];
  List<ContractCategory> _contractCategories = [];
  late JHijri _visitDateHijri;
  final VisitReportData _visitReportDate = VisitReportData();
  late final TextEditingController _clientNameController;
  late final TextEditingController _clientController;
  late final TextEditingController _clientAddressController;
  late final TextEditingController _contractNumberController;
  late final TextEditingController _visitDateController;
  late final TextEditingController _systemStatusController;
  late final TextEditingController _contractController;

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
    _visitDateHijri = JHijri.now();
    _visitDateController.text = _visitDateHijri.toString();
  }

  void _showSelectClientSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'اختيار العميل',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_clients.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _clients.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          itemBuilder: (ctx, i) {
                            final c = _clients[i];
                            final bool checked =
                                _selectedClient?.info.id == c.info.id;
                            return Container(
                              color: checked
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : null,
                              child: ListTile(
                                leading: const Icon(Icons.person_outline),
                                title: Text(
                                  c.info.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: checked
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      c.info.email,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      'Code: ${c.info.code}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                trailing: checked
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    _selectedClient = c;
                                    _selectedContract = null;
                                    _contractController.text = 'اختيار العقد';
                                    _clientController.text = c.info.name;
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                            );
                          },
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

  void _showSelectContractSheet() {
    List<ContractData> contracts = _contracts
        .where((c) => c.metaData.clientId == _selectedClient?.info.id)
        .toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'اختيار العقد',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: contracts.isEmpty
                          ? const Center(
                              child: Text('لا يوجد عقود لهذا العميل'))
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: contracts.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                              itemBuilder: (ctx, i) {
                                final c = contracts[i];
                                final bool checked =
                                    _selectedContract?.metaData.id ==
                                        c.metaData.id;
                                return Container(
                                  color: checked
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : null,
                                  child: ListTile(
                                    leading: const Icon(Icons.person_outline),
                                    title: Text(
                                      'عقد رقم: ${c.metaData.code}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: checked
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'تاريخ البدء: ${_formatDate(c.metaData.startDate!)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          'تاريخ النهاية: ${_formatDate(c.metaData.endDate!)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    trailing: checked
                                        ? const Icon(Icons.check_circle,
                                            color: Colors.green)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedContract = c;
                                        _contractController.text =
                                            'عقد رقم: ${c.metaData.code}';
                                        _contractNumberController.text =
                                            c.metaData.code.toString();
                                        _clientNameController.text =
                                            c.paramSecondPartyName ?? '';
                                        _clientAddressController.text =
                                            c.paramSecondPartyAddress ?? '';
                                        _visitDateController.text =
                                            JDateModel(dateTime: DateTime.now())
                                                .jhijri
                                                .toString();
                                      });
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                );
                              },
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
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

    // Row 0: merged across 2 columns (outer top/left/right borders)
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

    // Row 1: merged across 2 columns (row separator on top, sides true)
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
                    child: GestureDetector(
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
                      child: Text(
                        textAndController['controller'].text,
                        textDirection: TextDirection.rtl,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).reports),
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
        state.visitReportItems == null ||
        state.contractComponents == null ||
        state.contractCategories == null ||
        state.user == null ||
        state.user is! Employee) {
      return const Center(child: CircularProgressIndicator());
    }
    _employee = state.user;
    _clients = state.clients!;
    _contracts = state.contracts!;
    _contractComponents = state.contractComponents!;
    _contractCategories = state.contractCategories!;

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
                          'معلومات العقد',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: false,
                          initialValue: _employee?.branch.name ?? 'غير محدد',
                          readOnly: true,
                          onTap: _showSelectClientSheet,
                          decoration: const InputDecoration(
                            labelText: 'الفرع',
                            suffixIcon: Icon(Icons.corporate_fare),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: false,
                          initialValue: _employee?.info.name ?? 'غير محدد',
                          readOnly: true,
                          onTap: _showSelectClientSheet,
                          decoration: const InputDecoration(
                            labelText: 'الموظف',
                            suffixIcon: Icon(Icons.person),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _clientController,
                          readOnly: true,
                          onTap: _showSelectClientSheet,
                          decoration: const InputDecoration(
                            labelText: 'العميل',
                            hintText: 'اختيار العميل',
                            suffixIcon: Icon(Icons.person),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _contractController,
                          readOnly: true,
                          onTap: _showSelectContractSheet,
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
              const SizedBox(height: 24),
              ..._buildVisitReportItems(),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ReportsBloc>().add(SaveVisitReportRequested(
                        visitReport: _visitReportDate));
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildVisitReportItems() {
    final List<Widget> items = [];
    items.add(_buildMergedTable());
    items.add(ComponentsBuilder(
      components: _contractComponents,
      categories: _contractCategories,
      onChange: (data) {},
    ));
    return items;
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
    super.dispose();
  }
}
