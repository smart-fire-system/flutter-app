import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';
import 'view_contract_screen.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  List<ContractData> _contracts = [];
  List<ReportItem> _items = [];

  String _stateLabel(ContractState? state) {
    switch (state) {
      case ContractState.active:
        return 'ساري';
      case ContractState.pendingClient:
        return 'بانتظار العميل';
      case ContractState.requestCancellation:
        return 'طلب إلغاء';
      case ContractState.expired:
        return 'منتهي';
      case ContractState.cancelled:
        return 'ملغي';
      case ContractState.draft:
      default:
        return 'مسودة';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsBloc>().add(ReadContractsRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).reports),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            if (state is ReportsContractsLoaded && state.contracts.isNotEmpty) {
              _contracts = state.contracts;
              _items = state.items;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _contracts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final c = _contracts[i];
                  final meta = c.metaData;
                  String formatDate(DateTime? d) {
                    if (d == null) return '';
                    final y = d.year.toString().padLeft(4, '0');
                    final m = d.month.toString().padLeft(2, '0');
                    final dd = d.day.toString().padLeft(2, '0');
                    return '$y-$m-$dd';
                  }

                  Color stateColor() {
                    switch (meta.state) {
                      case ContractState.active:
                        return Colors.green;
                      case ContractState.pendingClient:
                        return Colors.orange;
                      case ContractState.requestCancellation:
                        return Colors.deepOrange;
                      case ContractState.expired:
                        return Colors.grey;
                      case ContractState.cancelled:
                        return Colors.red;
                      case ContractState.draft:
                      default:
                        return Colors.blueGrey;
                    }
                  }

                  final String codeText =
                      c.paramContractNumber?.isNotEmpty == true
                          ? c.paramContractNumber!
                          : (meta.code?.toString() ?? '');

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ViewContractScreen(
                              items: _items,
                              contract: c,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    codeText.isNotEmpty
                                        ? 'عقد رقم: $codeText'
                                        : 'عقد',
                                    style: CustomStyle.mediumTextBRed,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: stateColor().withOpacity(0.1),
                                    border: Border.all(
                                        color: stateColor(), width: 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    _stateLabel(meta.state),
                                    style: TextStyle(
                                      color: stateColor(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined,
                                    size: 18, color: CustomStyle.redDark),
                                const SizedBox(width: 6),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'ساري من ',
                                        style: CustomStyle.smallTextBRed,
                                      ),
                                      TextSpan(
                                        text: formatDate(meta.startDate),
                                        style: CustomStyle.smallText,
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: ' إلى ',
                                        style: CustomStyle.smallTextBRed,
                                      ),
                                      TextSpan(
                                        text: formatDate(meta.endDate),
                                        style: CustomStyle.smallText,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    size: 18, color: CustomStyle.redDark),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'الموظف: ',
                                          style: CustomStyle.smallTextBRed,
                                        ),
                                        TextSpan(
                                          text: meta.employee?.info.name ?? '-',
                                          style: CustomStyle.smallText,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.group_outlined,
                                    size: 18, color: CustomStyle.redDark),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'العميل: ',
                                          style: CustomStyle.smallTextBRed,
                                        ),
                                        TextSpan(
                                          text: meta.client?.info.name ?? '-',
                                          style: CustomStyle.smallText,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.apartment_outlined,
                                    size: 18, color: CustomStyle.redDark),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'الفرع: ',
                                          style: CustomStyle.smallTextBRed,
                                        ),
                                        TextSpan(
                                          text:
                                              meta.employee?.branch.name ?? '-',
                                          style: CustomStyle.smallText,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ReportsInitial) {
              // Optionally trigger loading event here
              context.read<ReportsBloc>().add(ReadContractsRequested());
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
