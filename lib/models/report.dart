import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';

class ContractItem {
  final ReportTextItem? text;
  final ReportCategoryItem? category;
  final ReportTableItem? table;
  ContractItem({this.text, this.category, this.table});
}

class ReportCategoryItem {
  List<String> types;
  final int? categoryIndex;
  ReportCategoryItem({required this.types, this.categoryIndex});
}

class ReportTableItem {
  List<List<ReportTextItem>> values;
  ReportTableItem({required this.values});
}

class ReportTextItem {
  final String templateValue;
  final Map<String, dynamic>? parameters;
  final TextAlign? align;
  final bool? bold;
  final bool? underlined;
  final Color? color;
  final Color? backgroundColor;
  final double paddingAfter;
  final bool addDivider;

  ReportTextItem({
    required this.templateValue,
    this.parameters,
    this.align,
    this.bold,
    this.underlined,
    this.color,
    this.backgroundColor,
    this.paddingAfter = 8,
    this.addDivider = false,
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

class ContractComponent {
  final String arName;
  final String enName;
  final String description;
  final int categoryIndex; // 0 = Other, otherwise 1-based index
  final int quantity;
  final String notes;
  ContractComponent({
    this.arName = '',
    this.enName = '',
    this.description = '',
    this.categoryIndex = 0,
    this.quantity = 0,
    this.notes = '',
  });
}

class ContractCategory {
  final String arName;
  final String enName;
  ContractCategory({
    this.arName = '',
    this.enName = '',
  });
}

class ContractComponentsData {
  ContractCategory category;
  List<ContractComponent> items;
  ContractComponentsData({required this.category, required this.items});
}

class ContractComponents {
  ContractComponents();
  List<ContractComponentsData> categories = [];

  Map<String, dynamic> toJson() {
    return {
      'componentsData': categories
          .map((c) => {
                'category': {
                  'arName': c.category.arName,
                  'enName': c.category.enName,
                },
                'items': c.items
                    .map((i) => {
                          'arName': i.arName,
                          'enName': i.enName,
                          'description': i.description,
                          'categoryIndex': i.categoryIndex,
                          'quantity': i.quantity,
                          'notes': i.notes,
                        })
                    .toList(),
              })
          .toList()
    };
  }

  factory ContractComponents.fromJson(Map<String, dynamic> json) {
    final comps = json['componentsData'];
    final ContractComponents data = ContractComponents();
    if (comps is List) {
      data.categories = comps.map((e) {
        final map = (e as Map).cast<String, dynamic>();
        final catMap = (map['category'] as Map?)?.cast<String, dynamic>() ?? {};
        final category = ContractCategory(
          arName: catMap['arName']?.toString() ?? '',
          enName: catMap['enName']?.toString() ?? '',
        );
        final itemsList = (map['items'] as List?) ?? [];
        final items = itemsList.map((it) {
          final itMap = (it as Map).cast<String, dynamic>();
          return ContractComponent(
            arName: itMap['arName']?.toString() ?? '',
            enName: itMap['enName']?.toString() ?? '',
            description: itMap['description']?.toString() ?? '',
            categoryIndex: (itMap['categoryIndex'] is int)
                ? itMap['categoryIndex'] as int
                : int.tryParse(itMap['categoryIndex']?.toString() ?? '') ?? 0,
            quantity: (itMap['quantity'] is int)
                ? itMap['quantity'] as int
                : int.tryParse(itMap['quantity']?.toString() ?? '') ?? 0,
            notes: itMap['notes']?.toString() ?? '',
          );
        }).toList();
        return ContractComponentsData(category: category, items: items);
      }).toList();
    }
    return data;
  }
}
