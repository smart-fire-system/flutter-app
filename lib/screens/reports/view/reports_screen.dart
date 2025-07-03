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

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<Map<String, dynamic>> _paramValues = [];
  // New state for table items
  final List<Map<String, Map<String, dynamic>>> _tableStates = [];

  // Store controllers for table cells
  final List<Map<String, Map<String, TextEditingController>>>
      _tableControllers = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).reports),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoaded && state.items.isNotEmpty) {
            // Display all items
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        } else if (item.image != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.network(item.image!.url),
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
                                  'exists': false,
                                  'quantity': '',
                                  'notes': '',
                                }
                            };
                            _tableControllers[idx] = {
                              for (var type in table.types)
                                type: {
                                  'quantity': TextEditingController(
                                      text: _tableStates[idx][type]![
                                          'quantity']),
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
                                if (table.title.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      table.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                Table(
                                  border: TableBorder.all(),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    const TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('النوع',
                                              textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('موجود',
                                              textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('العدد',
                                              textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('ملاحظات',
                                              textAlign: TextAlign.center),
                                        ),
                                      ],
                                    ),
                                    ...table.types.map((type) => TableRow(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(type,
                                                  textAlign: TextAlign.center),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Center(
                                                child: Checkbox(
                                                  value: typeStates[type]![
                                                      'exists'],
                                                  onChanged: (val) {
                                                    setState(() {
                                                      typeStates[type]![
                                                              'exists'] =
                                                          val ?? false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
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
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: TextField(
                                                decoration:
                                                    const InputDecoration(
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
                                        )),
                                  ],
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
                                  items:
                                      state.items.map((e) => e.text!).toList(),
                                  paramValues: _paramValues,
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
