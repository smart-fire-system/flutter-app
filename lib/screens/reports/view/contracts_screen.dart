import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';
import 'report_preview_screen.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  List<ContractData> _contracts = [];
  List<ReportItem> _items = [];
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
      body: BlocBuilder<ReportsBloc, ReportsState>(
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

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 0,
                  child: ListTile(
                    title: Text(
                      'من ${formatDate(meta.startDate)} إلى ${formatDate(meta.endDate)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('الموظف: ${meta.employee?.info.name ?? '-'}'),
                        Text('العميل: ${meta.client?.info.name ?? '-'}'),
                        Text('الفرع: ${meta.employee?.branch.name ?? '-'}'),
                        Text('الحالة: ${meta.state?.name ?? '-'}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ContractPreviewScreen(
                            items: _items,
                            contract: c,
                          ),
                        ),
                      );
                    },
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
