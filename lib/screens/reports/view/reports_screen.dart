import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:jhijri_picker/jhijri_picker.dart';
import 'package:fire_alarm_system/widgets/text_field.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/models/report.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportItem item = ReportItem(
    templateValue:
        'بعون من الله تعالى تم في يوم {{param_day}}\u00A0الموافق{{param_hijri_date}} هجرياً، الموافق {{param_gregorian_date}} ميلادياً الإتفاق بين كل من: ',
    parameters: {
      'param_day': DayParameter,
      'param_hijri_date': HijriDateParameter,
      'param_gregorian_date': GregorianDateParameter,
    },
  );

  // Store parameter values
  final Map<String, dynamic> _paramValues = {};

  @override
  void initState() {
    super.initState();
    // Initialize parameter values
    item.parameters!.forEach((key, type) {
      if (type == StringParameter) {
        _paramValues[key] = StringParameter();
      } else if (type == IntParameter) {
        _paramValues[key] = IntParameter();
      } else if (type == GregorianDateParameter) {
        _paramValues[key] = GregorianDateParameter();
      } else if (type == HijriDateParameter) {
        _paramValues[key] = HijriDateParameter();
      } else if (type == DayParameter) {
        _paramValues[key] = DayParameter();
      }
    });
  }

  List<Widget> _buildInlineTemplateWidgets(BuildContext context) {
    final RegExp regExp = RegExp(r'\{\{(.*?)\}\}');
    final List<Widget> widgets = [];
    final String template = item.templateValue;
    int currentIndex = 0;

    Iterable<RegExpMatch> matches = regExp.allMatches(template);
    for (final match in matches) {
      if (match.start > currentIndex) {
        widgets.add(Text(
          template.substring(currentIndex, match.start),
          style: CustomStyle.mediumText,
          textDirection: TextDirection.rtl,
        ));
      }
      final paramName = match.group(1)!;
      final paramType = item.parameters![paramName];
      Widget widget;
      if (paramType == StringParameter) {
        widget = GrowingTextField(
          value: _paramValues[paramName].text,
          onChanged: (value) {
            setState(() {
              _paramValues[paramName].value = value;
            });
          },
          maxWidth: MediaQuery.of(context).size.width,
          style: CustomStyle.smallTextRed,
          maxLines: 1,
          textDirection: TextDirection.rtl,
        );
      } else if (paramType == IntParameter) {
        widget = GrowingTextField(
          value: _paramValues[paramName].text,
          onChanged: (value) {
            setState(() {
              _paramValues[paramName].value = int.tryParse(value);
            });
          },
          keyboardType: TextInputType.number,
          maxWidth: MediaQuery.of(context).size.width,
          style: CustomStyle.smallTextRed,
          maxLines: 1,
          textDirection: TextDirection.rtl,
        );
      } else if (paramType == GregorianDateParameter) {
        widget = GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _paramValues[paramName].date ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                _paramValues[paramName].value = picked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _paramValues[paramName].text,
              style: CustomStyle.smallTextRed,
              textDirection: TextDirection.rtl,
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
                    JDateModel(jhijri: _paramValues[paramName].date?.jhijri));
            if (picked != null) {
              setState(() {
                _paramValues[paramName].value = picked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _paramValues[paramName].text,
              style: CustomStyle.smallTextRed,
              textDirection: TextDirection.rtl,
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
                          title: Text(DayParameter(value: day).text, style: CustomStyle.mediumText,),
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
                _paramValues[paramName].value = selectedDay;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _paramValues[paramName].text,
              style: CustomStyle.smallTextRed,
              textDirection: TextDirection.rtl,
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
      widgets.add(Text(
        template.substring(currentIndex),
        style: CustomStyle.mediumText,
        textDirection: TextDirection.rtl,
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).reports),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    textDirection: TextDirection.rtl,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: _buildInlineTemplateWidgets(context),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
