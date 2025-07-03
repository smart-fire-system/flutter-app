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
              }else if (item.table != null) {
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
                                child:
                                    Text('النوع', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child:
                                    Text('موجود', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child:
                                    Text('العدد', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text('ملاحظات',
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          ...table.types.map((type) {
                            final exists = tableData != null &&
                                tableData[type]?['exists'] == true;
                            final quantity = tableData != null
                                ? (tableData[type]?['quantity'] ?? '')
                                : '';
                            final notes = tableData != null
                                ? (tableData[type]?['notes'] ?? '')
                                : '';
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child:
                                      Text(type, textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Icon(
                                      exists
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color:
                                          exists ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(quantity.toString(),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(notes.toString(),
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            );
                          }).toList(),
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
