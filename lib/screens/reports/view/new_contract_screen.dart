import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:jhijri_picker/jhijri_picker.dart';
import 'package:fire_alarm_system/widgets/text_field.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({super.key});

  @override
  State<NewContractScreen> createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  List<Client> _clients = [];
  Client? _selectedClient;
  Employee? _employee;
  int _duplicatdDateIndex = 0;
  List<ContractComponent> _contractComponents = [];
  List<ContractCategory> _contractCategories = [];
  final List<Map<String, dynamic>> _paramValues = [];
  final List<Map<String, Map<String, dynamic>>> _tableStates = [];
  final List<Map<String, Map<String, TextEditingController>>>
      _tableControllers = [];
  // Local per-table selected types to avoid mutating bloc state
  final List<List<String>> _localTableTypes = [];
  final ContractData _contractData = ContractData();
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _clientController;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _clientController = TextEditingController();
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
                                    _clientController.text = c.info.name;
                                    _contractData.metaData.client = c;
                                    _contractData.metaData.clientId = c.info.id;
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

  Future<void> _pickStartDate() async {
    final DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _contractData.metaData.startDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _contractData.metaData.startDate = picked;
        _startDateController.text = _formatDate(picked);
        _contractData.metaData.startDate = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _contractData.metaData.endDate ??
          _contractData.metaData.startDate ??
          now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _contractData.metaData.endDate = picked;
        _endDateController.text = _formatDate(picked);
        _contractData.metaData.endDate = picked;
      });
    }
  }

  void _updateContractComponentsFromTables({
    required List<ContractItem> items,
    required List<ContractComponent> allComponents,
    required List<ContractCategory> categories,
  }) {
    final Map<int, List<ContractComponent>> categoryIndexToItems = {};
    final Map<String, Map<String, Map<String, String>>> details = {};
    for (final reportItem in items) {
      final table = reportItem.category;
      if (table == null) continue;
      final int categoryIndex = table.categoryIndex ?? 0;
      final String categoryKey = categoryIndex.toString();
      details.putIfAbsent(categoryKey, () => {});

      // Use local table types for this table index
      final int tableIdx = items.indexOf(reportItem);
      final List<String> localTypes =
          (tableIdx >= 0 && tableIdx < _localTableTypes.length)
              ? _localTableTypes[tableIdx]
              : const [];

      for (final String typeName in localTypes) {
        // Find the component by display name used in selection
        final ContractComponent matched = allComponents.firstWhere(
          (c) {
            final String name =
                (c.arName.trim().isNotEmpty ? c.arName.trim() : c.enName.trim())
                    .trim();
            return name == typeName;
          },
          orElse: () => ContractComponent(
            arName: typeName,
            enName: typeName,
            description: '',
            categoryIndex: categoryIndex,
          ),
        );
        categoryIndexToItems.putIfAbsent(categoryIndex, () => []);
        // Avoid duplicates per category
        if (!categoryIndexToItems[categoryIndex]!.any(
          (it) => (it.arName == matched.arName && it.enName == matched.enName),
        )) {
          categoryIndexToItems[categoryIndex]!.add(matched);
        }

        // Capture quantity and notes
        if (tableIdx >= 0 && tableIdx < _tableStates.length) {
          final typeStates = _tableStates[tableIdx];
          final q = typeStates[typeName]?['quantity']?.toString() ?? '';
          final n = typeStates[typeName]?['notes']?.toString() ?? '';
          details[categoryKey]![typeName] = {
            'quantity': q,
            'notes': n,
          };
        }
      }
    }

    _contractData.components = [
      for (final entry in categoryIndexToItems.entries)
        if (entry.key >= 0 && entry.key < categories.length)
          ContractComponentsData(
            category: categories[entry.key],
            items: entry.value,
          )
    ];
    _contractData.componentDetails = details;
  }

  void _initParamValues(int idx, ReportTextItem item) {
    if (_paramValues.length > idx && _paramValues[idx].isNotEmpty) return;
    while (_paramValues.length <= idx) {
      _paramValues.add({});
    }
    final paramMap = <String, dynamic>{};
    item.parameters?.forEach((key, type) {
      if (type == StringParameter) {
        paramMap[key] = StringParameter();
      } else if (type == IntParameter) {
        paramMap[key] = IntParameter();
      } else if (type == GregorianDateParameter) {
        paramMap[key] = GregorianDateParameter();
      } else if (type == HijriDateParameter) {
        paramMap[key] = HijriDateParameter();
        if (key == 'paramContractAddDate') {
          _duplicatdDateIndex = idx;
        }
      } else if (type == DayParameter) {
        paramMap[key] = DayParameter();
      }
    });
    _paramValues[idx] = paramMap;
  }

  void _updateContractDataFromParam(String key, dynamic typed) {
    String text;
    try {
      text = typed?.text ?? '';
    } catch (_) {
      text = typed?.toString() ?? '';
    }
    switch (key) {
      case 'paramContractNumber':
        _contractData.paramContractNumber = text;
        break;
      case 'paramContractAgreementDay':
        _contractData.paramContractAgreementDay = text;
        break;
      case 'paramContractAgreementHijriDate':
        _contractData.paramContractAgreementHijriDate = text;
        break;
      case 'paramContractAgreementGregorianDate':
        _contractData.paramContractAgreementGregorianDate = text;
        break;
      case 'paramFirstPartyName':
        _contractData.paramFirstPartyName = text;
        break;
      case 'paramFirstPartyCommNumber':
        _contractData.paramFirstPartyCommNumber = text;
        break;
      case 'paramFirstPartyAddress':
        _contractData.paramFirstPartyAddress = text;
        break;
      case 'paramFirstPartyRep':
        _contractData.paramFirstPartyRep = text;
        break;
      case 'paramFirstPartyRepIdNumber':
        _contractData.paramFirstPartyRepIdNumber = text;
        break;
      case 'paramFirstPartyG':
        _contractData.paramFirstPartyG = text;
        break;
      case 'paramSecondPartyName':
        _contractData.paramSecondPartyName = text;
        break;
      case 'paramSecondPartyCommNumber':
        _contractData.paramSecondPartyCommNumber = text;
        break;
      case 'paramSecondPartyAddress':
        _contractData.paramSecondPartyAddress = text;
        break;
      case 'paramSecondPartyRep':
        _contractData.paramSecondPartyRep = text;
        break;
      case 'paramSecondPartyRepIdNumber':
        _contractData.paramSecondPartyRepIdNumber = text;
        break;
      case 'paramSecondPartyG':
        _contractData.paramSecondPartyG = text;
        break;
      case 'paramContractAddDate':
        _contractData.paramContractAddDate = text;
        break;
      case 'paramContractPeriod':
        _contractData.paramContractPeriod = text;
        break;
      case 'paramContractAmount':
        _contractData.paramContractAmount = text;
        break;
    }
  }

  List<Widget> _buildInlineTemplateWidgets(BuildContext context, int itemIndex,
      ReportTextItem item, Map<String, dynamic> paramValues) {
    final RegExp regExp = RegExp(r'\{\{(.*?)\}\}');
    final List<Widget> widgets = [];
    final String template = item.templateValue;
    int currentIndex = 0;

    TextStyle baseStyle = CustomStyle.mediumText.copyWith(fontFamily: 'Arial');
    if (item.bold == true) {
      baseStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);
    }
    if (item.underlined == true) {
      baseStyle = baseStyle.copyWith(decoration: TextDecoration.underline);
    }
    if (item.color != null) baseStyle = baseStyle.copyWith(color: item.color);
    // backgroundColor handled in Container below

    Iterable<RegExpMatch> matches = regExp.allMatches(template);
    for (final match in matches) {
      if (match.start > currentIndex) {
        widgets.add(Container(
          color: item.backgroundColor,
          child: Text(
            template.substring(currentIndex, match.start),
            style: baseStyle,
            textDirection: TextDirection.rtl,
            textAlign: item.align,
          ),
        ));
      }
      final paramName = match.group(1)!;
      final paramType =
          item.parameters != null ? item.parameters![paramName] : null;
      Widget widget;
      if (paramType == StringParameter) {
        if (paramName == 'paramFirstPartyName') {
          paramValues[paramName].value =
              _employee!.branch.contractFirstParty!.name;
        } else if (paramName == 'paramFirstPartyCommNumber') {
          paramValues[paramName].value =
              _employee!.branch.contractFirstParty!.commercialRecord;
        } else if (paramName == 'paramFirstPartyAddress') {
          paramValues[paramName].value =
              _employee!.branch.contractFirstParty!.address;
        } else if (paramName == 'paramFirstPartyRep') {
          paramValues[paramName].value =
              _employee!.branch.contractFirstParty!.repName;
        } else if (paramName == 'paramFirstPartyRepIdNumber') {
          paramValues[paramName].value =
              _employee!.branch.contractFirstParty!.idNumber;
        } else if (paramName == 'paramFirstPartyG') {
          paramValues[paramName].value =
              _employee!.branch.contractFirstParty!.g;
        }
        widget = GrowingTextField(
          value: paramValues[paramName].text,
          enabled: !paramName.startsWith('paramFirstParty'),
          onChanged: (value) {
            setState(() {
              paramValues[paramName].value = value;
              _updateContractDataFromParam(paramName, paramValues[paramName]);
            });
          },
          maxWidth: MediaQuery.of(context).size.width,
          style: baseStyle,
          maxLines: 1,
          textDirection: TextDirection.rtl,
        );
      } else if (paramType == IntParameter) {
        widget = GrowingTextField(
          value: paramValues[paramName].text,
          onChanged: (value) {
            setState(() {
              paramValues[paramName].value = int.tryParse(value);
              _updateContractDataFromParam(paramName, paramValues[paramName]);
            });
          },
          keyboardType: TextInputType.number,
          maxWidth: MediaQuery.of(context).size.width,
          style: baseStyle,
          maxLines: 1,
          textDirection: TextDirection.rtl,
        );
      } else if (paramType == GregorianDateParameter) {
        widget = GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: paramValues[paramName].date ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                paramValues[paramName].value = picked;
                _updateContractDataFromParam(paramName, paramValues[paramName]);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
              color: item.backgroundColor,
            ),
            child: Text(
              paramValues[paramName].text,
              style: baseStyle,
              textDirection: TextDirection.rtl,
              textAlign: item.align,
            ),
          ),
        );
      } else if (paramType == HijriDateParameter) {
        widget = GestureDetector(
          onTap: () async {
            if (paramName == 'paramContractAddDate') return;
            JPickerValue? picked = await showGlobalDatePicker(
                context: context,
                pickerType: PickerType.JHijri,
                selectedDate:
                    JDateModel(jhijri: paramValues[paramName].date?.jhijri));
            if (picked != null) {
              setState(() {
                paramValues[paramName].value = picked;
                _updateContractDataFromParam(paramName, paramValues[paramName]);
                if (paramName == 'paramContractAgreementHijriDate') {
                  _paramValues[_duplicatdDateIndex]['paramContractAddDate']
                      .value = picked;
                  _updateContractDataFromParam(
                      'paramContractAddDate',
                      _paramValues[_duplicatdDateIndex]
                          ['paramContractAddDate']);
                }
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
              color: item.backgroundColor,
            ),
            child: Text(
              paramValues[paramName].text,
              style: baseStyle,
              textDirection: TextDirection.rtl,
              textAlign: item.align,
            ),
          ),
        );
      } else if (paramType == DayParameter) {
        widget = GestureDetector(
          onTap: () async {
            final selectedDay = await showDialog<Day>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView(
                      shrinkWrap: true,
                      children: Day.values.map((day) {
                        return ListTile(
                          title: Text(
                            DayParameter(value: day).text,
                            style: baseStyle,
                          ),
                          onTap: () {
                            Navigator.of(context).pop(day);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
            if (selectedDay != null) {
              setState(() {
                paramValues[paramName].value = selectedDay;
                _updateContractDataFromParam(paramName, paramValues[paramName]);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
              color: item.backgroundColor,
            ),
            child: Text(
              paramValues[paramName].text,
              style: baseStyle,
              textDirection: TextDirection.rtl,
              textAlign: item.align,
            ),
          ),
        );
      } else {
        widget = const SizedBox.shrink();
      }
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: widget,
      ));
      currentIndex = match.end;
    }
    // Add any remaining text after the last parameter
    if (currentIndex < template.length) {
      widgets.add(Container(
        color: item.backgroundColor,
        child: Text(
          template.substring(currentIndex),
          style: baseStyle,
          textDirection: TextDirection.rtl,
          textAlign: item.align,
        ),
      ));
    }
    return widgets;
  }

  WrapAlignment _mapTextAlignToWrapAlignment(TextAlign? align) {
    switch (align) {
      case TextAlign.center:
        return WrapAlignment.center;
      case TextAlign.right:
        return WrapAlignment.end;
      case TextAlign.left:
        return WrapAlignment.start;
      default:
        return WrapAlignment.start;
    }
  }

  void _showAddComponentSheet(
      {required int itemIndex, required ReportCategoryItem table}) {
    final allComponents = _contractComponents;
    final int categoryIndex = table.categoryIndex ?? 0;
    final filtered =
        allComponents.where((c) => c.categoryIndex == categoryIndex).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
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
                        'اختر مكون لإضافته',
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
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('لا توجد عناصر متاحة لهذه الفئة'),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final comp = filtered[i];
                        final name = (comp.arName.trim().isNotEmpty
                                ? comp.arName.trim()
                                : comp.enName.trim())
                            .trim();
                        // Ensure local table types list exists
                        while (_localTableTypes.length <= itemIndex) {
                          _localTableTypes.add([]);
                        }
                        final localTypes = _localTableTypes[itemIndex];
                        final alreadyAdded = localTypes.contains(name);
                        return ListTile(
                          leading: const Icon(Icons.add_box_outlined),
                          title: Text(
                            name.isEmpty ? comp.enName : name,
                            style: TextStyle(
                              color: alreadyAdded ? Colors.grey : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: comp.description.trim().isEmpty
                              ? null
                              : Text(
                                  comp.description.trim(),
                                  style: TextStyle(
                                    color: alreadyAdded ? Colors.grey : null,
                                  ),
                                ),
                          enabled: !alreadyAdded,
                          trailing: alreadyAdded
                              ? const Icon(Icons.check, color: Colors.grey)
                              : const Icon(Icons.add),
                          onTap: alreadyAdded
                              ? null
                              : () {
                                  setState(() {
                                    // Ensure table state containers exist
                                    while (_tableStates.length <= itemIndex) {
                                      _tableStates.add({});
                                      _tableControllers.add({});
                                    }
                                    final typeStates = _tableStates[itemIndex];
                                    final typeControllers =
                                        _tableControllers[itemIndex];

                                    // Add to local table types
                                    localTypes.add(name);

                                    // Initialize state and controllers for the new row if missing
                                    typeStates[name] ??= {
                                      'quantity': '',
                                      'notes': '',
                                    };
                                    typeControllers[name] ??= {
                                      'quantity': TextEditingController(
                                          text: typeStates[name]!['quantity']),
                                      'notes': TextEditingController(
                                          text: typeStates[name]!['notes']),
                                    };
                                  });
                                  Navigator.pop(ctx);
                                },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
        state.contractItems == null ||
        state.contractComponents == null ||
        state.contractCategories == null ||
        state.user == null ||
        state.user is! Employee) {
      return const Center(child: CircularProgressIndicator());
    }
    _employee = state.user;
    _clients = state.clients!;
    _contractData.metaData.employee = _employee;
    _contractData.metaData.employeeId = _employee?.info.id;
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
                          controller: _startDateController,
                          readOnly: true,
                          onTap: _pickStartDate,
                          decoration: const InputDecoration(
                            labelText: 'تاريخ بداية العقد',
                            suffixIcon: Icon(Icons.date_range),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _endDateController,
                          readOnly: true,
                          onTap: _pickEndDate,
                          decoration: const InputDecoration(
                            labelText: 'تاريخ نهاية العقد',
                            suffixIcon: Icon(Icons.event),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              ...state.contractItems!.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                if (item.text != null) {
                  _initParamValues(idx, item.text!);
                  final paramValues = _paramValues[idx];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            textDirection: TextDirection.rtl,
                            alignment:
                                _mapTextAlignToWrapAlignment(item.text!.align),
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: _buildInlineTemplateWidgets(
                                context, idx, item.text!, paramValues),
                          ),
                        ),
                      ),
                      SizedBox(height: item.text!.paddingAfter),
                      if (item.text!.addDivider)
                        const Divider(color: CustomStyle.redLight),
                    ],
                  );
                } else if (item.category != null) {
                  final table = item.category!;
                  // Initialize local lists and controllers/states for this table index
                  if (_localTableTypes.length <= idx) {
                    while (_localTableTypes.length <= idx) {
                      _localTableTypes.add([]);
                    }
                  }
                  if (_tableStates.length <= idx) {
                    while (_tableStates.length <= idx) {
                      _tableStates.add({});
                      _tableControllers.add({});
                    }
                    // Initialize empty for current local types
                    _tableStates[idx] = {
                      for (var type in _localTableTypes[idx])
                        type: {
                          'quantity': '',
                          'notes': '',
                        }
                    };
                    _tableControllers[idx] = {
                      for (var type in _localTableTypes[idx])
                        type: {
                          'quantity': TextEditingController(
                              text: _tableStates[idx][type]!['quantity']),
                          'notes': TextEditingController(
                              text: _tableStates[idx][type]!['notes']),
                        }
                    };
                  }
                  final typeStates = _tableStates[idx];
                  final typeControllers = _tableControllers[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          border: TableBorder.all(
                              color: Colors.grey.shade300, width: 1),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(48),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(2),
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
                                  child: Text('X',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
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
                            ..._localTableTypes[idx]
                                .asMap()
                                .entries
                                .map((entry) {
                              final i = entry.key;
                              final type = entry.value;
                              final isEven = i % 2 == 0;
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: isEven
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                    child: Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Colors.red),
                                        tooltip: 'حذف',
                                        onPressed: () {
                                          setState(() {
                                            final controllers =
                                                typeControllers.remove(type);
                                            controllers?['quantity']?.dispose();
                                            controllers?['notes']?.dispose();
                                            typeStates.remove(type);
                                            _localTableTypes[idx].remove(type);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child:
                                        Text(type, textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                      ),
                                      textAlign: TextAlign.center,
                                      controller:
                                          typeControllers[type]!['quantity'],
                                      onChanged: (val) {
                                        setState(() {
                                          typeStates[type]!['quantity'] = val;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                      ),
                                      textAlign: TextAlign.center,
                                      controller:
                                          typeControllers[type]!['notes'],
                                      onChanged: (val) {
                                        setState(() {
                                          typeStates[type]!['notes'] = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () => _showAddComponentSheet(
                                itemIndex: idx, table: table),
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _updateContractComponentsFromTables(
                      items: state.contractItems!,
                      allComponents: _contractComponents,
                      categories: _contractCategories,
                    );

                    context
                        .read<ReportsBloc>()
                        .add(SaveContractRequested(contract: _contractData));
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

  @override
  void dispose() {
    // Dispose all table controllers
    for (final table in _tableControllers) {
      for (final typeMap in table.values) {
        typeMap['quantity']?.dispose();
        typeMap['notes']?.dispose();
      }
    }
    _startDateController.dispose();
    _endDateController.dispose();
    _clientController.dispose();
    super.dispose();
  }
}
