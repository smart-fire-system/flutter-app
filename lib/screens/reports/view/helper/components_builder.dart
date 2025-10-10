import 'package:fire_alarm_system/models/report.dart';
import 'package:flutter/material.dart';

class ComponentsBuilder extends StatefulWidget {
  final List<ContractCategory>? categories;
  final List<ContractComponent>? components;
  final ContractComponents? componentsData;
  final bool showOnly;
  final void Function(ContractComponents)? onChange;
  const ComponentsBuilder({
    super.key,
    this.showOnly = false,
    this.componentsData,
    this.categories,
    this.components,
    this.onChange,
  }) : assert(
            showOnly == true
                ? componentsData != null
                : categories != null && components != null,
            'If showOnly is true, componentsData must be provided, otherwise categories and components must be provided');
  @override
  State<ComponentsBuilder> createState() => _ComponentsBuilderState();
}

class _ComponentsBuilderState extends State<ComponentsBuilder> {
  final List<List<Map<String, dynamic>>> _tableRows = [];
  final List<ContractComponent> _contractComponents = [];
  final List<ContractCategory> _contractCategories = [];

  @override
  void initState() {
    super.initState();
    if (widget.showOnly) {
      _contractCategories.addAll(
          widget.componentsData!.categories.map((c) => c.category).toList());
      _contractComponents.addAll(
          widget.componentsData!.categories.expand((c) => c.items).toList());
    } else {
      _contractCategories.addAll(widget.categories!);
      _contractComponents.addAll(widget.components!);
    }
    _preloadFromInitial();
    _emitChange();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _builsComponentsTable(),
    );
  }

  void _ensureRowsList(int categoryIndex) {
    while (_tableRows.length <= categoryIndex) {
      _tableRows.add([]);
    }
  }

  void _preloadFromInitial() {
    if (widget.componentsData?.categories.isEmpty ?? true) return;
    for (final group in widget.componentsData!.categories) {
      final int categoryIndex = _contractCategories.indexWhere((c) =>
          c.arName.trim() == group.category.arName.trim() &&
          c.enName.trim() == group.category.enName.trim());
      if (categoryIndex < 0) continue;
      _ensureRowsList(categoryIndex);
      for (final item in group.items) {
        final String ar = item.arName.trim();
        final String en = item.enName.trim();
        // Avoid duplicates
        final bool exists = _tableRows[categoryIndex].any((row) {
          final String dn = ((row['arName'] as String).trim().isNotEmpty
                  ? (row['arName'] as String).trim()
                  : (row['enName'] as String).trim())
              .trim();
          final String name = ar.isNotEmpty ? ar : en;
          return dn == name;
        });
        if (!exists) {
          _tableRows[categoryIndex].add({
            'arName': ar,
            'enName': en,
            'quantityController':
                TextEditingController(text: (item.quantity).toString()),
            'notesController': TextEditingController(text: item.notes),
          });
        }
      }
    }
  }

  void _emitChange() {
    final ContractComponents components = ContractComponents();
    for (int i = 0; i < _contractCategories.length; i++) {
      if (i >= _tableRows.length) break;
      final rows = _tableRows[i];
      if (rows.isEmpty) continue;
      final List<ContractComponent> items = rows.map((row) {
        final String ar = (row['arName'] as String?)?.trim() ?? '';
        final String en = (row['enName'] as String?)?.trim() ?? '';
        final String qtyText =
            (row['quantityController'] as TextEditingController?)
                    ?.text
                    .trim() ??
                '';
        final int qty = int.tryParse(qtyText.isEmpty ? '0' : qtyText) ?? 0;
        final String notes =
            (row['notesController'] as TextEditingController?)?.text ?? '';
        return ContractComponent(
          arName: ar,
          enName: en,
          description: '',
          categoryIndex: i,
          quantity: qty,
          notes: notes,
        );
      }).toList();
      components.categories.add(ContractComponentsData(
          category: _contractCategories[i], items: items));
    }
    widget.onChange?.call(components);
  }

  List<Widget> _builsComponentsTable() {
    final List<Widget> items = [];
    int runningIndex = 0; // global index across all categories
    // Determine display order: all except 'Other' then 'Other'
    final List<int> order =
        List<int>.generate(_contractCategories.length, (index) => index);
    order.sort((a, b) {
      final aIsOther =
          _contractCategories[a].enName.trim().toLowerCase() == 'other';
      final bIsOther =
          _contractCategories[b].enName.trim().toLowerCase() == 'other';
      if (aIsOther == bIsOther) return 0;
      return aIsOther ? 1 : -1; // 'Other' goes last
    });

    for (final i in order) {
      final cat = _contractCategories[i];
      _ensureRowsList(i);
      items.add(const SizedBox(height: 16));
      items.add(Text(
        '• ${cat.arName} - ${cat.enName}',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ));
      items.add(const SizedBox(height: 8));

      items.add(
        Table(
          border: TableBorder.all(color: Colors.grey.shade300, width: 1),
          columnWidths: widget.showOnly
              ? const <int, TableColumnWidth>{
                  0: FixedColumnWidth(48),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(2),
                }
              : const <int, TableColumnWidth>{
                  0: FixedColumnWidth(40),
                  1: FixedColumnWidth(48),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(2),
                },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 80, 82, 84)),
              children: [
                if (!widget.showOnly)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text('',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text('م',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text('النوع',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text('العدد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text('ملاحظات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            ..._tableRows[i].asMap().entries.map((entry) {
              final idx = entry.key;
              final row = entry.value;
              final int currentIndex = ++runningIndex;
              final String displayName =
                  '${(row['arName'] as String).trim()}${(row['arName'] as String).trim().isNotEmpty && (row['enName'] as String).trim().isNotEmpty ? ' - ' : ''}${(row['enName'] as String).trim()}';
              return TableRow(
                decoration: BoxDecoration(
                  color: idx % 2 == 0 ? Colors.grey.shade50 : Colors.white,
                ),
                children: [
                  // Column 0: Delete button
                  if (!widget.showOnly)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                              width: 24, height: 24),
                          tooltip: 'حذف',
                          iconSize: 18,
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              (row['quantityController']
                                      as TextEditingController)
                                  .dispose();
                              (row['notesController'] as TextEditingController)
                                  .dispose();
                              _tableRows[i].removeAt(idx);
                              _emitChange();
                            });
                          },
                        ),
                      ),
                    ),
                  // Column 1: Index
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Text('$currentIndex', textAlign: TextAlign.center),
                  ),
                  // Column 2: Component name
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Text(displayName, textAlign: TextAlign.center),
                  ),
                  // Column 3: Quantity
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: widget.showOnly
                        ? Text(
                            (row['quantityController'] as TextEditingController)
                                .text,
                            textAlign: TextAlign.center)
                        : TextField(
                            controller: row['quantityController']
                                as TextEditingController,
                            enabled: !widget.showOnly,
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 1.5),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            onChanged: (_) => _emitChange(),
                          ),
                  ),
                  // Column 4: Notes
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: widget.showOnly
                        ? Text(
                            (row['notesController'] as TextEditingController)
                                .text,
                            textAlign: TextAlign.center)
                        : TextField(
                            controller:
                                row['notesController'] as TextEditingController,
                            enabled: !widget.showOnly,
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 1.5),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            onChanged: (_) => _emitChange(),
                          ),
                  ),
                ],
              );
            }),
          ],
        ),
      );
      if (!widget.showOnly) {
        items.add(
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _showAddComponentSheet(categoryIndex: i),
              icon: const Icon(Icons.add),
              label: const Text('إضافة'),
            ),
          ),
        );
      }
    }
    return items;
  }

  void _showAddComponentSheet({required int categoryIndex}) {
    _ensureRowsList(categoryIndex);
    final filtered = _contractComponents
        .where((c) => c.categoryIndex == categoryIndex)
        .toList();
    final TextEditingController ar = TextEditingController();
    final TextEditingController en = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
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
                    const Expanded(
                      child: Text(
                        'اختر مكون لإضافته',
                        style: TextStyle(
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
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('لا توجد عناصر متاحة لهذه الفئة'),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final comp = filtered[i];
                        final name = (comp.arName.trim().isNotEmpty
                                ? comp.arName.trim()
                                : comp.enName.trim())
                            .trim();
                        final exists = _tableRows[categoryIndex].any((row) {
                          final String dn =
                              ((row['arName'] as String).trim().isNotEmpty
                                      ? (row['arName'] as String).trim()
                                      : (row['enName'] as String).trim())
                                  .trim();

                          return dn == name;
                        });
                        return ListTile(
                          leading: const Icon(Icons.add_box_outlined),
                          title: Text(
                            name.isEmpty ? comp.enName : name,
                            style: TextStyle(
                              color: exists ? Colors.grey : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: comp.description.trim().isEmpty
                              ? null
                              : Text(
                                  comp.description.trim(),
                                  style: TextStyle(
                                    color: exists ? Colors.grey : null,
                                  ),
                                ),
                          enabled: !exists,
                          trailing: exists
                              ? const Icon(Icons.check, color: Colors.grey)
                              : const Icon(Icons.add),
                          onTap: exists
                              ? null
                              : () {
                                  setState(() {
                                    _tableRows[categoryIndex].add({
                                      'arName': comp.arName.trim(),
                                      'enName': comp.enName.trim(),
                                      'quantityController':
                                          TextEditingController(),
                                      'notesController':
                                          TextEditingController(),
                                    });
                                    _emitChange();
                                  });
                                  Navigator.pop(ctx);
                                },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                const Text('إدخال يدوي'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ar,
                        decoration: const InputDecoration(
                          labelText: 'Arabic Name',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: en,
                        decoration: const InputDecoration(
                          labelText: 'English Name',
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () {
                      final String arName = ar.text.trim();
                      final String enName = en.text.trim();
                      if (arName.isEmpty && enName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Enter Arabic or English name')),
                        );
                        return;
                      }
                      final String disp = arName.isNotEmpty ? arName : enName;
                      final exists = _tableRows[categoryIndex].any((row) {
                        final String dn =
                            ((row['arName'] as String).trim().isNotEmpty
                                    ? (row['arName'] as String).trim()
                                    : (row['enName'] as String).trim())
                                .trim();
                        return dn == disp;
                      });
                      if (exists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Already added')),
                        );
                        return;
                      }
                      setState(() {
                        _tableRows[categoryIndex].add({
                          'arName': arName,
                          'enName': enName,
                          'quantityController': TextEditingController(),
                          'notesController': TextEditingController(),
                        });
                        _emitChange();
                      });
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (final rows in _tableRows) {
      for (final row in rows) {
        (row['quantityController'] as TextEditingController?)?.dispose();
        (row['notesController'] as TextEditingController?)?.dispose();
      }
    }
    super.dispose();
  }
}
