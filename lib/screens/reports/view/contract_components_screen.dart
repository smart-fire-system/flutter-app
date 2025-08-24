import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/screens/reports/bloc/event.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class ContractComponentsScreen extends StatefulWidget {
  const ContractComponentsScreen({super.key});

  @override
  State<ContractComponentsScreen> createState() =>
      _ContractComponentsScreenState();
}

enum _LocalStatus { normal, added, updated, deleted }

enum _SortBy { ar, en }

class _LocalComponent {
  ContractComponentItem item;
  _LocalStatus status;
  _LocalComponent({required this.item, required this.status});
}

class _ContractComponentsScreenState extends State<ContractComponentsScreen> {
  final List<_LocalComponent> _localItems = [];
  bool _initialized = false;
  bool _saving = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  _SortBy _sortBy = _SortBy.en;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<ReportsBloc>().add(ReportsContractComponentsRequested());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _saveAll() async {
    setState(() => _saving = true);
    final toSave = _localItems
        .where((e) => e.status != _LocalStatus.deleted)
        .map((e) => e.item)
        .toList();
    context.read<ReportsBloc>().add(
          ReportsContractComponentsSaveRequested(items: toSave),
        );
  }

  void _showBottomSheet({int? index}) {
    final bool isEdit = index != null;
    final ContractComponentItem? current =
        isEdit ? _localItems[index].item : null;
    final ar = TextEditingController(text: current?.arName ?? '');
    final en = TextEditingController(text: current?.enName ?? '');
    final desc = TextEditingController(text: current?.description ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isEdit ? 'Edit Component' : 'Add Contract Component',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ar,
                  decoration: InputDecoration(
                    labelText: 'Arabic Name',
                    hintText: 'اكتب الاسم بالعربية',
                    prefixIcon: const Icon(Icons.translate),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: en,
                  decoration: InputDecoration(
                    labelText: 'English Name',
                    hintText: 'Enter English name',
                    prefixIcon: const Icon(Icons.language),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: desc,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Optional description',
                    prefixIcon: const Icon(Icons.notes),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (isEdit)
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _localItems[index] = _LocalComponent(
                              item: ContractComponentItem(
                                arName: ar.text.trim(),
                                enName: en.text.trim(),
                                description: desc.text.trim(),
                              ),
                              status: _LocalStatus.deleted,
                            );
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    if (isEdit) const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () {
                        if (!isEdit &&
                            ar.text.trim().isEmpty &&
                            en.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please enter Arabic or English name')),
                          );
                          return;
                        }
                        Navigator.pop(ctx);
                        setState(() {
                          if (isEdit) {
                            _localItems[index] = _LocalComponent(
                              item: ContractComponentItem(
                                arName: ar.text.trim(),
                                enName: en.text.trim(),
                                description: desc.text.trim(),
                              ),
                              status: _LocalStatus.updated,
                            );
                          } else {
                            _searchText = '';
                            _searchController.clear();
                            _localItems.add(
                              _LocalComponent(
                                item: ContractComponentItem(
                                  arName: ar.text.trim(),
                                  enName: en.text.trim(),
                                  description: desc.text.trim(),
                                ),
                                status: _LocalStatus.added,
                              ),
                            );
                          }
                        });
                      },
                      icon: Icon(isEdit ? Icons.save : Icons.add),
                      label: Text(isEdit ? 'Update' : 'Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Components'),
        backgroundColor: CustomStyle.redDark,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBottomSheet(),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: BlocListener<ReportsBloc, ReportsState>(
        listener: (context, state) {
          if (state is ReportsSaved) {
            setState(() {
              for (final entry in _localItems) {
                if (entry.status != _LocalStatus.deleted) {
                  entry.status = _LocalStatus.normal;
                }
              }
              _localItems.removeWhere((e) => e.status == _LocalStatus.deleted);
              _saving = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved')),
            );
          }
        },
        child: BlocBuilder<ReportsBloc, ReportsState>(
          buildWhen: (prev, curr) =>
              curr is ReportsLoading || curr is ReportsContractComponentsLoaded,
          builder: (context, state) {
            if (state is ReportsLoading && !_initialized) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReportsContractComponentsLoaded && !_initialized) {
              _localItems.clear();
              for (final item in state.items) {
                _localItems.add(
                    _LocalComponent(item: item, status: _LocalStatus.normal));
              }
              _initialized = true;
            }
            if (_localItems.isEmpty) {
              return const Center(child: Text('No components yet'));
            }

            final String q = _searchText.trim().toLowerCase();
            final List<_LocalComponent> viewItems = _localItems
                .where((e) => q.isEmpty
                    ? true
                    : (e.item.arName.toLowerCase().contains(q) ||
                        e.item.enName.toLowerCase().contains(q) ||
                        e.item.description.toLowerCase().contains(q)))
                .toList();
            viewItems.sort((a, b) {
              final String ak =
                  _sortBy == _SortBy.ar ? a.item.arName : a.item.enName;
              final String bk =
                  _sortBy == _SortBy.ar ? b.item.arName : b.item.enName;
              return ak.toLowerCase().compareTo(bk.toLowerCase());
            });

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _saveAll,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving...' : 'Save'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search (AR/EN/Description)',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchText.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchText = '';
                                        _searchController.clear();
                                      });
                                    },
                                  ),
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (v) => setState(() => _searchText = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<_SortBy>(
                        value: _sortBy,
                        items: const [
                          DropdownMenuItem(
                              value: _SortBy.en, child: Text('Sort: EN')),
                          DropdownMenuItem(
                              value: _SortBy.ar, child: Text('Sort: AR')),
                        ],
                        onChanged: (v) =>
                            setState(() => _sortBy = v ?? _SortBy.en),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final entry = viewItems[index];
                      Color? color;
                      switch (entry.status) {
                        case _LocalStatus.added:
                          color = Colors.green.withValues(alpha: 0.50);
                          break;
                        case _LocalStatus.updated:
                          color = Colors.orange.withValues(alpha: 0.50);
                          break;
                        case _LocalStatus.deleted:
                          color = Colors.red.withValues(alpha: 0.50);
                          break;
                        case _LocalStatus.normal:
                          color = null;
                          break;
                      }
                      final String arName = entry.item.arName.trim();
                      final String enName = entry.item.enName.trim();
                      final String desc = entry.item.description.trim();
                      final bool bothNames =
                          arName.isNotEmpty && enName.isNotEmpty;
                      final String singleName =
                          enName.isNotEmpty ? enName : arName;

                      return Card(
                        color: color,
                        child: ListTile(
                          onTap: () => _showBottomSheet(
                              index: _localItems.indexOf(entry)),
                          leading: const Icon(Icons.category),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (bothNames) ...[
                                Text('Arabic Name: $arName',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text('English Name: $enName',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ] else ...[
                                Text('Name: $singleName',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ],
                          ),
                          subtitle: desc.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Description: $desc',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                )
                              : null,
                          isThreeLine: desc.isNotEmpty,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
