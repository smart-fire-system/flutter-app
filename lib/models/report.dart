
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';

class ReportItem {
  String templateValue;
  Map<String, Type>? parameters;
  TextDirection? direction;
  ReportItem({
    required this.templateValue,
    this.parameters,
    this.direction,
  });
}

class StringParameter {
  String? value;
  StringParameter({this.value});
  String get text => value ?? '';
}

class IntParameter {
  int? value;
  IntParameter({this.value});
  int? get number => value;
  String get text => value?.toString() ?? '';
}

class GregorianDateParameter {
  DateTime? value;
  GregorianDateParameter({this.value});
  DateTime? get date => value;
  String get day => value?.toString().split(' ')[0] ?? '';
  String get month => value?.toString().split(' ')[1] ?? '';
  String get year => value?.toString().split(' ')[2] ?? '';
  String get text => value?.toString().split(' ')[0] ?? '';
}

class HijriDateParameter {
  JPickerValue? value;
  HijriDateParameter({this.value});
  String get text => value?.jhijri.toString() ?? '';
  JPickerValue? get date => value;
}

class DayParameter {
  Day? value;
  DayParameter({this.value});
  Day? get day => value;
  String get text {
    switch (value) {
      case Day.saturday:
        return 'السبت';
      case Day.sunday:
        return 'الأحد';
      case Day.monday:
        return 'الإثنين';
      case Day.tuesday:
        return 'الثلاثاء';
      case Day.wednesday:
        return 'الأربعاء';
      case Day.thursday:
        return 'الخميس';
      case Day.friday:
        return 'الجمعة';
      default:
        return '';
    }
  }
}
