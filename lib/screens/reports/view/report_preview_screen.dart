import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/contract_data.dart';

class ContractPreviewScreen extends StatelessWidget {
  final List<dynamic> items;
  final ContractData contract;

  const ContractPreviewScreen({
    super.key,
    required this.items,
    required this.contract,
  });

  String _paramText(String key) {
    switch (key) {
      case 'paramContractNumber':
        return contract.paramContractNumber ?? '';
      case 'paramContractAgreementDay':
        return contract.paramContractAgreementDay ?? '';
      case 'paramContractAgreementHijriDate':
        return contract.paramContractAgreementHijriDate ?? '';
      case 'paramContractAgreementGregorianDate':
        return contract.paramContractAgreementGregorianDate ?? '';
      case 'paramFirstPartyName':
        return contract.paramFirstPartyName ?? '';
      case 'paramFirstPartyCommNumber':
        return contract.paramFirstPartyCommNumber ?? '';
      case 'paramFirstPartyAddress':
        return contract.paramFirstPartyAddress ?? '';
      case 'paramFirstPartyRep':
        return contract.paramFirstPartyRep ?? '';
      case 'paramFirstPartyRepIdNumber':
        return contract.paramFirstPartyRepIdNumber ?? '';
      case 'paramFirstPartyG':
        return contract.paramFirstPartyG ?? '';
      case 'paramSecondPartyName':
        return contract.paramSecondPartyName ?? '';
      case 'paramSecondPartyCommNumber':
        return contract.paramSecondPartyCommNumber ?? '';
      case 'paramSecondPartyAddress':
        return contract.paramSecondPartyAddress ?? '';
      case 'paramSecondPartyRep':
        return contract.paramSecondPartyRep ?? '';
      case 'paramSecondPartyRepIdNumber':
        return contract.paramSecondPartyRepIdNumber ?? '';
      case 'paramSecondPartyG':
        return contract.paramSecondPartyG ?? '';
      case 'paramContractAddDate':
        return contract.paramContractAddDate ?? '';
      case 'paramContractPeriod':
        return contract.paramContractPeriod ?? '';
      case 'paramContractAmount':
        return contract.paramContractAmount ?? '';
      default:
        return '';
    }
  }

  String _renderTemplate(ReportTextItem item) {
    String result = item.templateValue;
    if (item.parameters != null) {
      item.parameters!.forEach((key, type) {
        final text = _paramText(key);
        result = result.replaceAll('{{$key}}', text);
      });
    }
    return result;
  }

  bool _isCategoryTitle(ReportTextItem item) {
    final t = item.templateValue.trim();
    return t.startsWith('• ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Widget _buildContractInfoCard(BuildContext context) {
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
            Row(
              children: [
                const Expanded(child: Text('الفرع')),
                Text(contract.metaData.employee?.branch.name ?? 'غير محدد'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('الموظف')),
                Text(contract.metaData.employee?.info.name ?? 'غير محدد'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('العميل')),
                Text(contract.metaData.client?.info.name ?? 'غير محدد'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('تاريخ بداية العقد')),
                Text(_formatDate(contract.metaData.startDate)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('تاريخ نهاية العقد')),
                Text(_formatDate(contract.metaData.endDate)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _typesForCategory(int? categoryIndex) {
    if (categoryIndex == null) return const [];
    final List<String> names = [];
    for (final cat in contract.components) {
      for (final item in cat.items) {
        if (item.categoryIndex == categoryIndex) {
          final String name = (item.arName.trim().isNotEmpty
                  ? item.arName.trim()
                  : item.enName.trim())
              .trim();
          if (!names.contains(name)) names.add(name);
        }
      }
    }
    return names;
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
            itemCount: items.length + 1,
            separatorBuilder: (context, idx) {
              if (idx == 0) return const SizedBox(height: 16);
              final realIdx = idx - 1;
              return SizedBox(
                  height: (items[realIdx]?.text?.paddingAfter ?? 0));
            },
            itemBuilder: (context, idx) {
              if (idx == 0) {
                return _buildContractInfoCard(context);
              }
              final realIdx = idx - 1;
              final item = items[realIdx];
              if (item.text != null) {
                // Skip category title if next table has no selected types (from contract)
                if (_isCategoryTitle(item.text) && realIdx + 1 < items.length) {
                  final table = items[realIdx + 1]?.table;
                  final hasAny =
                      _typesForCategory(table?.categoryIndex).isNotEmpty;
                  if (!hasAny) return const SizedBox.shrink();
                }
                final text = _renderTemplate(item.text);
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
                final table = item.table;
                final types = _typesForCategory(table.categoryIndex);
                if (types.isEmpty) return const SizedBox.shrink();
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
                          ...types.asMap().entries.map((entry) {
                            final i = entry.key;
                            final type = entry.value;
                            final isEven = i % 2 == 0;
                            final details = contract.componentDetails[
                                        table.categoryIndex?.toString() ?? '']
                                    ?[type] ??
                                const {};
                            final quantity = details['quantity'] ?? '';
                            final notes = details['notes'] ?? '';
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
                                  child: Text(quantity,
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child:
                                      Text(notes, textAlign: TextAlign.center),
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
