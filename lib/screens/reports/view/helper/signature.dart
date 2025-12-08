import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/signature.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SignatureHelper {
  static Widget buildSignaturesSection(
      BuildContext context, ContractData contract) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSignatureBox(
                    context: context,
                    title: 'الطرف الأول',
                    subtitle: contract.metaData.employee?.branch
                            .contractFirstParty.name ??
                        '',
                    signature: contract.metaData.employeeSignature,
                    signatureUrl: contract.metaData.employee?.branch
                        .contractFirstParty.signatureUrl,
                  ),
                  const SizedBox(width: 12),
                  buildSignatureBox(
                    context: context,
                    title: 'الطرف الثاني',
                    subtitle: contract.metaData.client?.info.name ?? '',
                    signature: contract.metaData.clientSignature,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildSignaturesSectionVisitReport(
      BuildContext context, VisitReportData visitReport) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSignatureBox(
                    context: context,
                    title: 'إدارة العمليات – القسم الفني - الصيانة',
                    subtitle: visitReport.contractMetaData.employee?.branch
                            .contractFirstParty.name ??
                        '',
                    signature: visitReport.employeeSignature,
                    signatureUrl: visitReport.contractMetaData.employee?.branch
                        .contractFirstParty.signatureUrl,
                  ),
                  const SizedBox(width: 12),
                  buildSignatureBox(
                    context: context,
                    title: 'إقرار العميل باستلام التقرير',
                    subtitle: visitReport.paramClientName ?? '',
                    signature: visitReport.clientSignature,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildSignatureBox({
    required BuildContext context,
    required String title,
    required String subtitle,
    SignatureData? signature,
    String? signatureUrl,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.right,
              style: CustomStyle.smallTextBRed,
            ),
            const SizedBox(height: 8),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: CustomStyle.smallText,
              ),
            ),
            const SizedBox(height: 8),
            if (signature != null && signature.name != null) ...[
              Center(
                child: GestureDetector(
                  onTap: () => showSignatureInfoDialog(
                      context, title, subtitle, signature,
                      signatureUrl: signatureUrl),
                  child: QrImageView(
                    data: signature.name ?? '',
                    version: QrVersions.auto,
                    size: 100,
                  ),
                ),
              ),
              Text(
                signature.name ?? '',
                textAlign: TextAlign.center,
                style: CustomStyle.smallText,
              ),
              if (signatureUrl != null)
                Image.network(signatureUrl, height: 100),
            ]
          ],
        ),
      ),
    );
  }

  static void showSignatureInfoDialog(BuildContext context, String title,
      String subtitle, SignatureData signature,
      {String? signatureUrl}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(title, style: CustomStyle.mediumTextBRed),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(subtitle, style: CustomStyle.smallText),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: QrImageView(
                          data: signature.name ?? '',
                          version: QrVersions.auto,
                        ),
                      ),
                      if (signatureUrl != null)
                        Image.network(signatureUrl, height: 100),
                    ],
                  ),
                  Table(
                    border:
                        TableBorder.all(color: Colors.grey.shade300, width: 1),
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('كود التوقيع',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(signature.name?.toString() ?? '-',
                              style: CustomStyle.smallText,
                              textAlign: TextAlign.right),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('تاريخ التوقيع',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            (() {
                              final v = signature.createdAt?.toDate();
                              if (v == null) return '-';
                              return DateHelper.formatDate(v);
                            })(),
                            style: CustomStyle.smallText,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('اسم المستخدم',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(signature.user?.name ?? '-',
                              style: CustomStyle.smallText,
                              textAlign: TextAlign.right),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('كود المستخدم',
                              style: CustomStyle.smallTextBRed,
                              textAlign: TextAlign.right),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(signature.user?.code.toString() ?? '-',
                              style: CustomStyle.smallText,
                              textAlign: TextAlign.right),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }
}
