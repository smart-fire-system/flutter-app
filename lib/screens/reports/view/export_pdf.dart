import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/screens/reports/view/common.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pw_colors;
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';

class ExportPdf {
  Future<void> contract(
      {required BuildContext context,
      required List<dynamic> items,
      required ContractData contract}) async {
    try {
      // Load Arabic-capable fonts (Noto Naskh Arabic): try assets first, then HTTP
      Future<pw.Font?> tryLoadAssetFont(String assetPath) async {
        try {
          final data = await rootBundle.load(assetPath);
          return pw.Font.ttf(data);
        } catch (_) {
          return null;
        }
      }

      Future<pw.Font> loadHttpFont(String url) async {
        final resp =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 12));
        if (resp.statusCode != 200) {
          throw Exception('HTTP ${resp.statusCode}');
        }
        final bytes = Uint8List.fromList(resp.bodyBytes);
        return pw.Font.ttf(bytes.buffer.asByteData());
      }

      Future<pw.Font> loadHttpFontFromCandidates(List<String> urls) async {
        for (final url in urls) {
          try {
            return await loadHttpFont(url);
          } catch (_) {
            // try next
          }
        }
        throw Exception('No font URL reachable');
      }

      final pw.Font baseFont = (await tryLoadAssetFont(
              'assets/fonts/NotoNaskhArabic-Regular.ttf')) ??
          await loadHttpFontFromCandidates([
            'https://raw.githubusercontent.com/google/fonts/main/ofl/notonaskharabic/NotoNaskhArabic-Regular.ttf',
            'https://raw.githubusercontent.com/google/fonts/main/ofl/notokufiarabic/NotoKufiArabic-Regular.ttf',
            'https://raw.githubusercontent.com/google/fonts/main/ofl/amiri/Amiri-Regular.ttf',
          ]);
      final pw.Font boldFont =
          (await tryLoadAssetFont('assets/fonts/NotoNaskhArabic-Bold.ttf')) ??
              await loadHttpFontFromCandidates([
                'https://raw.githubusercontent.com/google/fonts/main/ofl/notonaskharabic/NotoNaskhArabic-Bold.ttf',
                'https://raw.githubusercontent.com/google/fonts/main/ofl/notokufiarabic/NotoKufiArabic-Bold.ttf',
                'https://raw.githubusercontent.com/google/fonts/main/ofl/amiri/Amiri-Bold.ttf',
              ]);

      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: baseFont,
          bold: boldFont,
        ),
      );

      pw.TextAlign toPwAlign(TextAlign? a) {
        switch (a) {
          case TextAlign.left:
            return pw.TextAlign.left;
          case TextAlign.center:
            return pw.TextAlign.center;
          case TextAlign.right:
            return pw.TextAlign.right;
          case TextAlign.justify:
            return pw.TextAlign.justify;
          case TextAlign.start:
            return pw.TextAlign.start;
          case TextAlign.end:
            return pw.TextAlign.end;
          default:
            return pw.TextAlign.right;
        }
      }

      String toArabicIndicDigits(String input) {
        return input.replaceAllMapped(RegExp(r'[0-9]'), (m) {
          final int western = m.group(0)!.codeUnitAt(0) - 0x30;
          return String.fromCharCode(0x0660 + western);
        });
      }

      String normalizeRtlListPrefix(String input) {
        final match = RegExp(r'^\s*([0-9]+)([\-\.\)\:])?\s*').firstMatch(input);
        if (match == null) return input;
        final String digits = match.group(1) ?? '';
        final String punct = match.group(2) ?? '';
        final String rest = input.substring(match.end);
        const String rlm = '\u200F';
        final String arabicDigits = toArabicIndicDigits(digits);
        final String prefix = '$rlm$arabicDigits$punct$rlm ';
        return prefix + rest;
      }

      String enforceRtl(String s) {
        if (s.isEmpty) return s;
        String t = s;
        // If the line contains Arabic characters, normalize numbering
        if (RegExp(r'[\u0600-\u06FF]').hasMatch(t)) {
          t = normalizeRtlListPrefix(t);
          t = toArabicIndicDigits(t);
        }
        return '\u202B$t\u202C';
      }

      pw.Widget buildSignatureBox({
        required String title,
        required SignatureData signature,
        required String fallbackName,
      }) {
        final String name = signature.name?.trim().isNotEmpty == true
            ? signature.name!.trim()
            : fallbackName;
        final String dateStr = signature.createdAt?.toDate().toString() ?? '';
        return pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: pw_colors.PdfColors.grey400, width: 1),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Text(
                enforceRtl(title),
                textAlign: pw.TextAlign.right,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                height: 48,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: pw_colors.PdfColors.grey300,
                    width: 1,
                  ),
                  color: pw_colors.PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      enforceRtl('الاسم: ${name.isEmpty ? '-' : name}').trim(),
                      textAlign: pw.TextAlign.right,
                      textDirection: pw.TextDirection.rtl,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Text(
                    enforceRtl('التاريخ: ${dateStr.isEmpty ? '-' : dateStr}')
                        .trim(),
                    textAlign: pw.TextAlign.right,
                    textDirection: pw.TextDirection.rtl,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      List<pw.Widget> buildSignatures() {
        final emp = contract.metaData.employeeSignature;
        final cli = contract.metaData.clientSignature;
        final empName = contract.metaData.employee?.info.name ?? '';
        final cliName = contract.metaData.client?.info.name ?? '';
        return [
          pw.SizedBox(height: 16),
          pw.Row(
            children: [
              pw.Expanded(
                child: buildSignatureBox(
                  title: 'توقيع الموظف',
                  signature: emp,
                  fallbackName: empName,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: buildSignatureBox(
                  title: 'توقيع العميل',
                  signature: cli,
                  fallbackName: cliName,
                ),
              ),
            ],
          ),
        ];
      }

      List<pw.Widget> buildBody() {
        final List<pw.Widget> body = [];
        for (int realIdx = 0; realIdx < items.length; realIdx++) {
          final item = items[realIdx];
          if (item.text != null) {
            if (ContractsCommon().isCategoryTitle(item.text) &&
                realIdx + 1 < items.length) {
              final table = items[realIdx + 1]?.table;
              final hasAny = ContractsCommon()
                  .typesForCategory(contract, table?.categoryIndex)
                  .isNotEmpty;
              if (!hasAny) {
                continue;
              }
            }

            final String text = enforceRtl(
                ContractsCommon().renderTemplate(contract, item.text));
            pw.TextStyle style = const pw.TextStyle(fontSize: 12);
            if (item.text.bold == true) {
              style = style.copyWith(fontWeight: pw.FontWeight.bold);
            }
            if (item.text.underlined == true) {
              style = style.copyWith(decoration: pw.TextDecoration.underline);
            }

            body.add(
              pw.Container(
                width: double.infinity,
                color: pw_colors.PdfColors.white,
                child: pw.Text(
                  text,
                  textAlign: toPwAlign(item.text.align),
                  textDirection: pw.TextDirection.rtl,
                  style: style,
                ),
              ),
            );
          } else if (item.table != null) {
            final table = item.table;
            final types = ContractsCommon()
                .typesForCategory(contract, table.categoryIndex);
            if (types.isEmpty) continue;

            body.add(pw.SizedBox(height: 8));
            body.add(
              pw.Table(
                border: pw.TableBorder.all(
                  color: pw_colors.PdfColors.grey300,
                  width: 1,
                ),
                columnWidths: const <int, pw.TableColumnWidth>{
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(2),
                },
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: pw_colors.PdfColors.grey700,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: 8, horizontal: 6),
                        child: pw.Text(enforceRtl('ملاحظات'),
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: pw_colors.PdfColors.white)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: 8, horizontal: 6),
                        child: pw.Text(enforceRtl('العدد'),
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: pw_colors.PdfColors.white)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: 8, horizontal: 6),
                        child: pw.Text(enforceRtl('النوع'),
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: pw_colors.PdfColors.white)),
                      ),
                    ],
                  ),
                  ...types.asMap().entries.map((entry) {
                    final i = entry.key;
                    final type = entry.value;
                    final details = contract.componentDetails[
                            table.categoryIndex?.toString() ?? '']?[type] ??
                        const {};
                    final quantity = details['quantity'] ?? '';
                    final notes = details['notes'] ?? '';
                    final rowColor = (i % 2 == 0)
                        ? pw_colors.PdfColors.grey100
                        : pw_colors.PdfColors.white;
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(color: rowColor),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              vertical: 8, horizontal: 6),
                          child: pw.Text(enforceRtl(notes),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              vertical: 8, horizontal: 6),
                          child:
                              pw.Text(quantity, textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              vertical: 8, horizontal: 6),
                          child: pw.Text(enforceRtl(type),
                              textAlign: pw.TextAlign.center,
                              textDirection: pw.TextDirection.rtl),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            );
          }

          // Spacing between sections
          body.add(pw.SizedBox(height: 10));
        }

        return body;
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: pw_colors.PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          build: (context) => [
            ...buildBody(),
            ...buildSignatures(),
          ],
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تصدير PDF: $e')),
        );
      }
    }
  }
}
