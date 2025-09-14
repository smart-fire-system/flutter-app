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
import 'report_preview_screen.dart';

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({super.key});

  @override
  State<NewContractScreen> createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  List<Client> _clients = [];
  Client? _selectedClient;
  final List<Map<String, dynamic>> _paramValues = [];
  // New state for table items
  final List<Map<String, Map<String, dynamic>>> _tableStates = [];

  // Store controllers for table cells
  final List<Map<String, Map<String, TextEditingController>>>
      _tableControllers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsBloc>().add(ReportsItemsRequested());
    });
  }

  void _showSelectClientSheet() {
    Client? tempClient =
        _selectedClient ?? (_clients.isNotEmpty ? _clients.first : null);

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
                                tempClient?.info.id == c.info.id;
                            return Container(
                              color: checked
                                  ? Colors.green.withOpacity(0.06)
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
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('إلغاء'),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedClient = tempClient;
                            });
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('تأكيد'),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
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
      } else if (type == DayParameter) {
        paramMap[key] = DayParameter();
      }
    });
    _paramValues[idx] = paramMap;
  }

  List<Widget> _buildInlineTemplateWidgets(BuildContext context,
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
        widget = GrowingTextField(
          value: paramValues[paramName].text,
          onChanged: (value) {
            setState(() {
              paramValues[paramName].value = value;
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
            JPickerValue? picked = await showGlobalDatePicker(
                context: context,
                pickerType: PickerType.JHijri,
                selectedDate:
                    JDateModel(jhijri: paramValues[paramName].date?.jhijri));
            if (picked != null) {
              setState(() {
                paramValues[paramName].value = picked;
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
      {required int itemIndex, required ReportTableItem table}) {
    final bloc = context.read<ReportsBloc>();
    final allComponents = bloc.components ?? [];
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
                        final alreadyAdded = table.types.contains(name);
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

                                    // Add to table types
                                    table.types.add(name);

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
          if (state is ReportsNewContractInfoLoaded && state.items.isNotEmpty) {
            _clients = state.clients;
            // Display all items
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showSelectClientSheet,
                          icon: const Icon(Icons.group_add_outlined),
                          label: const Text('اختيار العميل'),
                        ),
                      ),
                      if (_selectedClient != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            'العميل: ${_selectedClient?.info.name ?? 'غير محدد'}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ...state.items.asMap().entries.map((entry) {
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
                                    alignment: _mapTextAlignToWrapAlignment(
                                        item.text!.align),
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: _buildInlineTemplateWidgets(
                                        context, item.text!, paramValues),
                                  ),
                                ),
                              ),
                              SizedBox(height: item.text!.paddingAfter),
                              if (item.text!.addDivider)
                                const Divider(color: CustomStyle.redLight),
                            ],
                          );
                        } else if (item.table != null) {
                          final table = item.table!;
                          // Use _tableStates for table item state
                          if (_tableStates.length <= idx) {
                            while (_tableStates.length <= idx) {
                              _tableStates.add({});
                              _tableControllers.add({});
                            }
                            _tableStates[idx] = {
                              for (var type in table.types)
                                type: {
                                  'quantity': '',
                                  'notes': '',
                                }
                            };
                            _tableControllers[idx] = {
                              for (var type in table.types)
                                type: {
                                  'quantity': TextEditingController(
                                      text: _tableStates[idx]
                                          [type]!['quantity']),
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
                                    ...table.types.asMap().entries.map((entry) {
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
                                                        typeControllers
                                                            .remove(type);
                                                    controllers?['quantity']
                                                        ?.dispose();
                                                    controllers?['notes']
                                                        ?.dispose();
                                                    typeStates.remove(type);
                                                    table.types.remove(type);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 8),
                                            child: Text(type,
                                                textAlign: TextAlign.center),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 8),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                              ),
                                              textAlign: TextAlign.center,
                                              controller: typeControllers[
                                                  type]!['quantity'],
                                              onChanged: (val) {
                                                setState(() {
                                                  typeStates[type]![
                                                      'quantity'] = val;
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
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                              ),
                                              textAlign: TextAlign.center,
                                              controller: typeControllers[
                                                  type]!['notes'],
                                              onChanged: (val) {
                                                setState(() {
                                                  typeStates[type]!['notes'] =
                                                      val;
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
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ReportPreviewScreen(
                                  items: state.items,
                                  paramValues: _paramValues,
                                  tableStates: _tableStates,
                                ),
                              ),
                            );
                          },
                          child: const Text('View'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ReportsInitial) {
            // Optionally trigger loading event here
            context.read<ReportsBloc>().add(ReportsItemsRequested());
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
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
    super.dispose();
  }
}
