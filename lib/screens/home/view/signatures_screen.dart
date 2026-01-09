import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/signature.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SignaturesScreen extends StatefulWidget {
  const SignaturesScreen({super.key});

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  final TextEditingController _nameController = TextEditingController();
  SignatureData? _signature;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _validate([String? name]) async {
    final l10n = AppLocalizations.of(context)!;
    final trimmed = (name ?? _nameController.text).trim();
    setState(() {
      _busy = true;
      _error = null;
      _signature = null;
    });

    if (trimmed.isEmpty) {
      setState(() {
        _busy = false;
        _error = l10n.signatures_empty_error;
      });
      return;
    }

    final repo = context.read<AppRepository>().reportsRepository;
    final sig = repo.validateSignature(trimmed);

    setState(() {
      _busy = false;
      _signature = sig;
      _error = sig == null ? l10n.signatures_invalid_error : null;
    });
  }

  Future<void> _scanQr() async {
    final scanned = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const SignatureQrScannerScreen()),
    );
    if (!mounted) return;
    final value = scanned?.trim() ?? '';
    if (value.isEmpty) return;

    _nameController.text = value;
    await _validate(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: l10n.signatures_title,
        leading: const Icon(Icons.qr_code_scanner),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _validate(),
                decoration: InputDecoration(
                  labelText: l10n.signatures_id_label,
                  hintText: l10n.signatures_id_hint,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: l10n.signatures_scan_qr_tooltip,
                    onPressed: _busy ? null : _scanQr,
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _busy ? null : _validate,
                      icon: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(l10n.signatures_validate_button),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _busy
                        ? null
                        : () {
                            setState(() {
                              _nameController.clear();
                              _signature = null;
                              _error = null;
                            });
                          },
                    icon: const Icon(Icons.clear),
                    label: Text(l10n.signatures_clear_button),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_error != null)
                _MessageBanner(
                  message: _error!,
                  background: const Color(0xFFFEE2E2),
                  foreground: CustomStyle.redDark,
                  icon: Icons.error_outline,
                ),
              if (_signature != null) _SignatureCard(signature: _signature!),
              if (_error == null && _signature == null)
                _MessageBanner(
                  message: l10n.signatures_enter_or_scan_hint,
                  background: const Color(0xFFEFF6FF),
                  foreground: const Color(0xFF1D4ED8),
                  icon: Icons.info_outline,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignatureCard extends StatelessWidget {
  final SignatureData signature;
  const _SignatureCard({required this.signature});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sigName = (signature.name ?? '').trim();
    final isContractSignature = sigName.startsWith('C');
    final isVisitReportSignature = sigName.startsWith('V');
    final signerChar = sigName.length >= 2 ? sigName[1].toUpperCase() : '';
    final signerRole = signerChar == 'C'
        ? l10n.signatures_role_client
        : signerChar == 'E'
            ? l10n.signatures_role_employee
            : l10n.signatures_role_unknown;

    final createdAt = signature.createdAt?.toDate();
    final createdAtText =
        createdAt == null ? '-' : DateHelper.formatDate(createdAt);

    final visitReport = isVisitReportSignature
        ? context
            .read<AppRepository>()
            .reportsRepository
            .getVisitReport(signature.visitReportId ?? '')
        : null;
    final contract = isContractSignature
        ? context
            .read<AppRepository>()
            .reportsRepository
            .getContract(signature.contractId ?? '')
        : null;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if ((signature.name ?? '').isNotEmpty) ...[
              Center(
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: QrImageView(
                    data: signature.name ?? '',
                    version: QrVersions.auto,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                signature.name ?? '',
                textAlign: TextAlign.center,
                style: CustomStyle.smallText,
              ),
              const SizedBox(height: 12),
            ],
            _section(
              title: l10n.signatures_section_signature_summary,
              children: [
                _kv(l10n.signatures_field_signature_id,
                    sigName.isEmpty ? '-' : sigName),
                _kv(
                  l10n.signatures_field_signature_code,
                  signature.code?.toString() ?? '-',
                ),
                _kv(l10n.signatures_field_signed_at, createdAtText),
                _kv(
                  l10n.signatures_field_type,
                  isContractSignature
                      ? l10n.signatures_type_contract
                      : isVisitReportSignature
                          ? l10n.signatures_type_visit_report
                          : l10n.signatures_type_unknown,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _section(
              title: l10n.signatures_section_user_summary,
              children: [
                _kv(l10n.signatures_field_role, signerRole),
                _kv(l10n.signatures_field_name, signature.user?.name ?? '-'),
                _kv(
                  l10n.signatures_field_user_code,
                  signature.user?.code.toString() ?? '-',
                ),
                _kv(l10n.signatures_field_email, signature.user?.email ?? '-'),
                _kv(l10n.signatures_field_phone,
                    signature.user?.phoneNumber ?? '-'),
              ],
            ),
            const SizedBox(height: 12),
            _section(
              title: isContractSignature
                  ? l10n.signatures_section_contract_summary
                  : isVisitReportSignature
                      ? l10n.signatures_section_visit_report_summary
                      : l10n.signatures_section_report_summary,
              children: [
                if (isContractSignature) ...[
                  _kv(l10n.signatures_field_contract_code,
                      contract?.metaData.code?.toString() ?? '-'),
                  _kv(
                    l10n.signatures_field_contract_state,
                    contract?.metaData.state?.name ?? '-',
                  ),
                  _kv(
                    l10n.signatures_field_contract_number,
                    contract?.paramContractNumber ?? '-',
                  ),
                  _kv(l10n.signatures_field_client,
                      contract?.metaData.client?.info.name ?? '-'),
                  _kv(l10n.signatures_field_employee,
                      contract?.metaData.employee?.info.name ?? '-'),
                ] else if (isVisitReportSignature) ...[
                  _kv(l10n.signatures_field_visit_report_code,
                      visitReport?.code?.toString() ?? '-'),
                  _kv(l10n.signatures_field_contract_code,
                      visitReport?.contractMetaData.code?.toString() ?? '-'),
                  _kv(l10n.signatures_field_contract_state,
                      visitReport?.contractMetaData.state?.name ?? '-'),
                  _kv(l10n.signatures_field_client,
                      visitReport?.paramClientName ?? '-'),
                  _kv(l10n.signatures_field_visit_date,
                      visitReport?.paramVisitDate ?? '-'),
                ] else ...[
                  _kv(l10n.signatures_field_contract_id,
                      signature.contractId ?? '-'),
                  _kv(l10n.signatures_field_visit_report_id,
                      signature.visitReportId ?? '-'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: CustomStyle.smallTextBRed),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              k,
              style: CustomStyle.smallTextBRed,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              v,
              style: CustomStyle.smallText,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBanner extends StatelessWidget {
  final String message;
  final Color background;
  final Color foreground;
  final IconData icon;

  const _MessageBanner({
    required this.message,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: foreground.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

class SignatureQrScannerScreen extends StatefulWidget {
  const SignatureQrScannerScreen({super.key});

  @override
  State<SignatureQrScannerScreen> createState() =>
      _SignatureQrScannerScreenState();
}

class _SignatureQrScannerScreenState extends State<SignatureQrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _popped = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _popOnce(String value) {
    if (_popped) return;
    _popped = true;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: l10n.signatures_scan_title,
        leading: const Icon(Icons.qr_code_scanner),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;
              final raw = capture.barcodes.first.rawValue?.trim() ?? '';
              if (raw.isEmpty) return;
              _popOnce(raw);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.signatures_point_camera_hint,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.signatures_toggle_flash_tooltip,
                        onPressed: () => _controller.toggleTorch(),
                        icon: const Icon(Icons.flash_on, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
