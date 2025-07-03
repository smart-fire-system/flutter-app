import 'package:flutter/material.dart';
import 'package:fire_alarm_system/models/report.dart';

class ReportPreviewScreen extends StatelessWidget {
  final List<ReportItem> items;
  final List<Map<String, dynamic>> paramValues;

  const ReportPreviewScreen({
    super.key,
    required this.items,
    required this.paramValues,
  });

  String _renderTemplate(ReportItem item, Map<String, dynamic> paramValues) {
    String result = item.templateValue;
    if (item.parameters != null) {
      item.parameters!.forEach((key, type) {
        final value = paramValues[key];
        String text = '';
        if (value != null && value.text != null) {
          text = value.text;
        }
        result = result.replaceAll('{{$key}}', text);
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, idx) =>
                SizedBox(height: items[idx].paddingAfter),
            itemBuilder: (context, idx) {
              final item = items[idx];
              final params = idx < paramValues.length
                  ? Map<String, dynamic>.from(paramValues[idx])
                  : <String, dynamic>{};
              final text = _renderTemplate(item, params);
              TextStyle style =
                  const TextStyle(fontFamily: 'Arial', fontSize: 16);
              if (item.bold == true) {
                style = style.copyWith(fontWeight: FontWeight.bold);
              }
              if (item.underlined == true) {
                style = style.copyWith(decoration: TextDecoration.underline);
              }
              if (item.color != null) style = style.copyWith(color: item.color);
              return Container(
                color: item.backgroundColor,
                width: double.infinity,
                child: Text(
                  text,
                  style: style,
                  textAlign: item.align,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
