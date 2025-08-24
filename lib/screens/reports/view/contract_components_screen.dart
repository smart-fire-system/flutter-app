import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/models/report.dart';

class ContractComponentsScreen extends StatelessWidget {
  const ContractComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Contract Components'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newItem = await showDialog<ContractComponentItem>(
            context: context,
            builder: (context) {
              final ar = TextEditingController();
              final en = TextEditingController();
              final desc = TextEditingController();
              return AlertDialog(
                title: const Text('Add Contract Component'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: ar,
                        decoration:
                            const InputDecoration(labelText: 'Arabic Name'),
                      ),
                      TextField(
                        controller: en,
                        decoration:
                            const InputDecoration(labelText: 'English Name'),
                      ),
                      TextField(
                        controller: desc,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(
                      context,
                      ContractComponentItem(
                        arName: ar.text.trim(),
                        enName: en.text.trim(),
                        description: desc.text.trim(),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
          if (newItem != null && context.mounted) {
            context
                .read<ReportsBloc>()
                .add(ReportsContractComponentsAddRequested(item: newItem));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReportsContractComponentsLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No components yet'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ReportsBloc>()
                    .add(ReportsContractComponentsRequested());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.category),
                      title: Text(
                        item.enName.isNotEmpty ? item.enName : item.arName,
                      ),
                      subtitle: Text(item.description),
                    ),
                  );
                },
              ),
            );
          }
          // For ReportsInitial or any other state, trigger load and show spinner
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context
                  .read<ReportsBloc>()
                  .add(ReportsContractComponentsRequested());
            }
          });
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
