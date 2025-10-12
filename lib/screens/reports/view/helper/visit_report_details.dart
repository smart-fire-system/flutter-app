import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/helper.dart';
import 'package:flutter/material.dart';

class VisitReportDetails extends StatefulWidget {
  final VisitReportData visitReport;
  final ContractData contract;
  const VisitReportDetails(
      {super.key, required this.visitReport, required this.contract});

  @override
  State<VisitReportDetails> createState() => _VisitReportDetailsState();
}

class _VisitReportDetailsState extends State<VisitReportDetails> {
  Widget _buildMergedTable() {
    Color borderColor = Colors.grey.shade300;

    Widget cell(
        {Widget? child,
        bool top = true,
        bool right = true,
        bool bottom = true,
        bool left = true}) {
      return Container(
        constraints: const BoxConstraints(minHeight: 48),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            right: right
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            bottom: bottom
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            left: left
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: child == null
            ? const SizedBox.shrink()
            : SizedBox(width: double.infinity, child: child),
      );
    }

    List<Widget> rows = [];

    Map<String, dynamic> getTextAndValue(int row) {
      switch (row) {
        case 2:
          return {
            'text': 'اسم العميل\nClient Name',
            'value': widget.visitReport.paramClientName
          };
        case 3:
          return {
            'text': 'عنوان العميل\nClient Address',
            'value': widget.visitReport.paramClientAddress
          };
        case 4:
          return {
            'text': 'رقم العقد\nContract Number',
            'value': widget.visitReport.paramContractNumber
          };

        case 5:
          return {
            'text': 'تاريخ الزيارة\nVisit Date',
            'value': widget.visitReport.paramVisitDate
          };
        case 6:
          return {
            'text': 'حالة النظام\nSystem Status',
            'value': widget.visitReport.paramSystemStatus
          };
        default:
          return {'text': '', 'value': ''};
      }
    }

    rows.add(Row(
      children: [
        Expanded(
          flex: 2,
          child: cell(
            child: const Center(
              child: Text(
                'تقرير عن حالة انظمة انذار واطفاء الحريق',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            top: true,
            bottom: false,
            left: true,
            right: true,
          ),
        ),
      ],
    ));

    rows.add(Row(
      children: [
        Expanded(
          flex: 2,
          child: cell(
            child: const Center(
              child: Text(
                'Fire Alarm & Fire Fighting Systems Maintenance Report',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            top: true,
            bottom: false,
            left: true,
            right: true,
          ),
        ),
      ],
    ));

    for (int r = 2; r < 7; r++) {
      final bool isLast = r == 6;
      final Map<String, dynamic> textAndValue = getTextAndValue(r);
      rows.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: borderColor, width: 1),
              bottom: isLast
                  ? BorderSide(color: borderColor, width: 1)
                  : BorderSide.none,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: cell(
                    child:
                        Text(textAndValue['text'], textAlign: TextAlign.center),
                    top: false,
                    bottom: false,
                    left: false,
                    right: true,
                  ),
                ),
                Expanded(
                  child: cell(
                    child: Text(textAndValue['value'] ?? '',
                        textAlign: TextAlign.center),
                    top: false,
                    bottom: false,
                    left: true,
                    right: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: rows,
        ),
      ),
    );
  }

  Widget _buildResult() {
    Color borderColor = Colors.grey.shade300;

    Widget cell(
        {Widget? child,
        bool top = true,
        bool right = true,
        bool bottom = true,
        bool left = true}) {
      return Container(
        constraints: const BoxConstraints(minHeight: 48),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            right: right
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            bottom: bottom
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
            left: left
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: child == null
            ? const SizedBox.shrink()
            : SizedBox(width: double.infinity, child: child),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                  bottom: BorderSide.none,
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: cell(
                        child: const Text('حالة الأنظمة\nSystem Status',
                            textAlign: TextAlign.center),
                        top: false,
                        bottom: false,
                        left: false,
                        right: true,
                      ),
                    ),
                    Expanded(
                      child: cell(
                        child: Text(
                            widget.visitReport.paramSystemStatusBool == '1'
                                ? 'ملائم - Suitable'
                                : 'غير ملائم - Unsuitable',
                            textAlign: TextAlign.center),
                        top: false,
                        bottom: false,
                        left: true,
                        right: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: cell(
                        child: const Text('ملاحظات\nNotes',
                            textAlign: TextAlign.center),
                        top: false,
                        bottom: false,
                        left: false,
                        right: true,
                      ),
                    ),
                    Expanded(
                      child: cell(
                        child: Text(widget.visitReport.paramNotes ?? '',
                            textAlign: TextAlign.center),
                        top: false,
                        bottom: false,
                        left: true,
                        right: true,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMergedTable(),
              const Text(
                'ادارة السلامة في الدفاع المدني بمنطقة المدينة المنورة المحترمين',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Text(
                '•	قامت فرقة الصيانة بزيارة روتينية للموقع الخاص بالعميل والكشف الكامل على نظام الإنذار والإطفاء المكون من: -',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              ComponentsBuilder(
                componentsData: widget.visitReport.componentsData,
                showOnly: true,
              ),
              const SizedBox(height: 16),
              _buildResult(),
              const SizedBox(height: 16),
              SignatureHelper.buildSignaturesSectionVisitReport(
                context,
                widget.visitReport,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
