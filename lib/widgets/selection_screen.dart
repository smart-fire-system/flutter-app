import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class UserSelectionResult {
  final String id;
  final String name;
  UserSelectionResult({required this.id, required this.name});
}

class UserSelectionScreen extends StatelessWidget {
  final String? selectedUserId;
  final List<UserInfo> users;
  const UserSelectionScreen(
      {super.key, this.selectedUserId, required this.users});
  @override
  Widget build(BuildContext context) {
    return _SelectionScreen<UserSelectionResult>(
      title: S.of(context).user,
      items: users
          .map((user) => _SelectionItem(
                id: user.id,
                name: user.name,
                code: user.code.toString(),
                email: user.email,
              ))
          .toList(),
      selectedId: selectedUserId,
      onSelect: (item) {
        Navigator.pop(
            context, UserSelectionResult(id: item.id, name: item.name));
      },
    );
  }
}

class CompanySelectionResult {
  final String id;
  final String name;
  CompanySelectionResult({required this.id, required this.name});
}

class CompanySelectionScreen extends StatelessWidget {
  final String? selectedCompanyId;
  final List<Company> companies;
  const CompanySelectionScreen(
      {super.key, this.selectedCompanyId, required this.companies});
  @override
  Widget build(BuildContext context) {
    return _SelectionScreen<CompanySelectionResult>(
      title: S.of(context).company,
      items: companies
          .map((c) => _SelectionItem(
                id: c.id ?? '',
                name: c.name,
                code: c.code?.toString() ?? '',
                email: c.email,
              ))
          .toList(),
      selectedId: selectedCompanyId,
      onSelect: (item) {
        Navigator.pop(
            context, CompanySelectionResult(id: item.id, name: item.name));
      },
    );
  }
}

class BranchSelectionResult {
  final String id;
  final String name;
  BranchSelectionResult({required this.id, required this.name});
}

class BranchSelectionScreen extends StatelessWidget {
  final String companyId;
  final String? selectedBranchId;
  final List<Branch> branches;
  const BranchSelectionScreen(
      {super.key,
      required this.companyId,
      this.selectedBranchId,
      required this.branches});
  @override
  Widget build(BuildContext context) {
    return _SelectionScreen<BranchSelectionResult>(
      title: S.of(context).branch,
      items: branches
          .map((b) => _SelectionItem(
                id: b.id ?? '',
                name: b.name,
                code: b.code?.toString() ?? '',
                email: b.email,
              ))
          .toList(),
      selectedId: selectedBranchId,
      onSelect: (item) {
        Navigator.pop(
            context, BranchSelectionResult(id: item.id, name: item.name));
      },
    );
  }
}

class _SelectionItem {
  final String id;
  final String name;
  final String code;
  final String email;
  _SelectionItem(
      {required this.id,
      required this.name,
      required this.code,
      required this.email});
}

class _SelectionScreen<T> extends StatefulWidget {
  final String title;
  final List<_SelectionItem> items;
  final void Function(_SelectionItem) onSelect;
  final String? selectedId;
  const _SelectionScreen(
      {required this.title,
      required this.items,
      required this.onSelect,
      this.selectedId});
  @override
  State<_SelectionScreen<T>> createState() => _SelectionScreenState<T>();
}

class _SelectionScreenState<T> extends State<_SelectionScreen<T>> {
  String _search = '';
  @override
  Widget build(BuildContext context) {
    var filtered = widget.items.where((item) {
      final q = _search.toLowerCase();
      return item.name.toLowerCase().contains(q) ||
          item.code.toLowerCase().contains(q) ||
          item.email.toLowerCase().contains(q);
    }).toList();
    if (widget.selectedId != null) {
      final idx = filtered.indexWhere((item) => item.id == widget.selectedId);
      if (idx > 0) {
        final selectedItem = filtered.removeAt(idx);
        filtered.insert(0, selectedItem);
      }
    }
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.of(context).searchBy,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(S.of(context).noUsersToView))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = widget.selectedId == item.id;
                      return Card(
                        child: ListTile(
                          leading: Text(
                            item.code.toString(),
                            style: CustomStyle.mediumTextBRed,
                          ),
                          title: Text(
                            item.name,
                            style: CustomStyle.mediumTextBRed,
                          ),
                          subtitle: Text(item.email),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () => widget.onSelect(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
