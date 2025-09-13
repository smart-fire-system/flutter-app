import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/models/report.dart';

class ReportPreviewScreen extends StatelessWidget {
  final List<dynamic> items;
  final List<Map<String, dynamic>> paramValues;
  final List<Map<String, Map<String, dynamic>>>? tableStates;

  const ReportPreviewScreen({
    super.key,
    required this.items,
    required this.paramValues,
    this.tableStates,
  });

  String _renderTemplate(
      ReportTextItem item, Map<String, dynamic> paramValues) {
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
                SizedBox(height: (items[idx]?.text?.paddingAfter ?? 0)),
            itemBuilder: (context, idx) {
              final item = items[idx];
              if (item.text != null) {
                final params = idx < paramValues.length
                    ? Map<String, dynamic>.from(paramValues[idx])
                    : <String, dynamic>{};
                final text = _renderTemplate(item.text, params);
                TextStyle style =
                    const TextStyle(fontFamily: 'Arial', fontSize: 16);
                if (item.text.bold == true) {
                  style = style.copyWith(fontWeight: FontWeight.bold);
                }
                if (item.text.underlined == true) {
                  style = style.copyWith(decoration: TextDecoration.underline);
                }
                if (item.text.color != null) {
                  style = style.copyWith(color: item.text.color);
                }
                return Container(
                  color: item.text.backgroundColor,
                  width: double.infinity,
                  child: Text(
                    text,
                    style: style,
                    textAlign: item.text.align,
                  ),
                );
              } else if (item.table != null) {
                final tableData =
                    (tableStates != null && idx < tableStates!.length)
                        ? tableStates![idx]
                        : null;
                final table = item.table;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        border: TableBorder.all(
                            color: Colors.grey.shade300, width: 1),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(2),
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
                            final tableDataRow = tableData;
                            final quantity = tableDataRow != null
                                ? (tableDataRow[type]?['quantity'] ?? '')
                                : '';
                            final notes = tableDataRow != null
                                ? (tableDataRow[type]?['notes'] ?? '')
                                : '';
                            return TableRow(
                              decoration: BoxDecoration(
                                color:
                                    isEven ? Colors.grey.shade50 : Colors.white,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child:
                                      Text(type, textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(quantity.toString(),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(notes.toString(),
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
