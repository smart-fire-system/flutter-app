import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import 'view_user.dart';

class UsersHierarchyScreen extends StatelessWidget {
  const UsersHierarchyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).users),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersAuthenticated) {
            return _HierarchyList(state: state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _HierarchyList extends StatelessWidget {
  final UsersAuthenticated state;
  const _HierarchyList({required this.state});

  @override
  Widget build(BuildContext context) {
    final List<Widget> sections = [];

    // Master Admins
    if (state.masterAdmins.isNotEmpty) {
      sections.add(
        Card(
          child: ExpansionTile(
            leading: const Icon(Icons.security, color: Colors.redAccent),
            title: Text(S.of(context).masterAdmin),
            children: state.masterAdmins
                .map((m) => ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(m.info.name),
                      subtitle: Text(m.info.email),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserInfoScreen(userId: m.info.id),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    }

    // Admins
    if (state.admins.isNotEmpty) {
      sections.add(
        Card(
          child: ExpansionTile(
            leading: const Icon(Icons.admin_panel_settings_outlined,
                color: Colors.orange),
            title: Text(S.of(context).admin),
            children: state.admins
                .map((a) => ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(a.info.name),
                      subtitle: Text(a.info.email),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserInfoScreen(userId: a.info.id),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    }

    // Companies hierarchy
    final Map<String, Company> companyById = {
      for (final c in state.companies) c.id.toString(): c
    };
    final Map<String, List<CompanyManager>> managersByCompanyId = {};
    for (final cm in state.companyManagers) {
      managersByCompanyId.putIfAbsent(cm.company.id.toString(), () => []);
      managersByCompanyId[cm.company.id.toString()]!.add(cm);
    }
    final Map<String, List<Branch>> branchesByCompanyId = {};
    for (final b in state.branches) {
      branchesByCompanyId.putIfAbsent(b.company.id.toString(), () => []);
      branchesByCompanyId[b.company.id.toString()]!.add(b);
    }
    final Map<String, List<BranchManager>> branchManagersByBranchId = {};
    for (final bm in state.branchManagers) {
      branchManagersByBranchId.putIfAbsent(bm.branch.id.toString(), () => []);
      branchManagersByBranchId[bm.branch.id.toString()]!.add(bm);
    }
    final Map<String, List<Employee>> employeesByBranchId = {};
    for (final e in state.employees) {
      employeesByBranchId.putIfAbsent(e.branch.id.toString(), () => []);
      employeesByBranchId[e.branch.id.toString()]!.add(e);
    }
    final Map<String, List<Client>> clientsByBranchId = {};
    for (final c in state.clients) {
      clientsByBranchId.putIfAbsent(c.branch.id.toString(), () => []);
      clientsByBranchId[c.branch.id.toString()]!.add(c);
    }

    for (final companyEntry in companyById.entries) {
      final company = companyEntry.value;
      final managers = managersByCompanyId[company.id] ?? const [];
      final companyBranches = branchesByCompanyId[company.id] ?? const [];
      sections.add(
        Card(
          child: ExpansionTile(
            leading: const Icon(Icons.business_outlined, color: Colors.blue),
            title: Row(
              children: [
                Expanded(child: Text(company.name)),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/company/details',
                      arguments: company.id,
                    );
                  },
                  icon: const Icon(Icons.visibility_outlined,
                      color: Colors.green),
                  label: const Text(''),
                ),
              ],
            ),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            children: [
              if (managers.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16),
                  child: ExpansionTile(
                    leading: const Icon(Icons.manage_accounts_outlined,
                        color: Colors.blueGrey),
                    title: Text(S.of(context).companyManager),
                    children: managers
                        .map((m) => ListTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(m.info.name),
                              subtitle: Text(m.info.email),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UserInfoScreen(userId: m.info.id),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ...companyBranches.map((branch) {
                final branchManagers =
                    branchManagersByBranchId[branch.id] ?? const [];
                final branchEmployees =
                    employeesByBranchId[branch.id] ?? const [];
                final branchClients = clientsByBranchId[branch.id] ?? const [];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16),
                  child: ExpansionTile(
                    leading: const Icon(Icons.corporate_fare_outlined,
                        color: Colors.teal),
                    title: Row(
                      children: [
                        Expanded(child: Text(branch.name)),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/branch/details',
                              arguments: branch.id,
                            );
                          },
                          icon: const Icon(Icons.visibility_outlined,
                              color: Colors.green),
                          label: const Text(''),
                        ),
                      ],
                    ),
                    children: [
                      if (branchManagers.isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 16),
                          child: ExpansionTile(
                            leading: const Icon(Icons.badge_outlined,
                                color: Colors.green),
                            title: Text(S.of(context).branchManager),
                            children: branchManagers
                                .map((bm) => ListTile(
                                      leading: const Icon(Icons.person_outline),
                                      title: Text(bm.info.name),
                                      subtitle: Text(bm.info.email),
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => UserInfoScreen(
                                              userId: bm.info.id),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      if (branchEmployees.isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 16),
                          child: ExpansionTile(
                            leading: const Icon(Icons.engineering_outlined,
                                color: Colors.brown),
                            title: Text(S.of(context).employee),
                            children: branchEmployees
                                .map((emp) => ListTile(
                                      leading: const Icon(Icons.person_outline),
                                      title: Text(emp.info.name),
                                      subtitle: Text(emp.info.email),
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => UserInfoScreen(
                                              userId: emp.info.id),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      if (branchClients.isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 16),
                          child: ExpansionTile(
                            leading: const Icon(Icons.group_outlined,
                                color: Colors.purple),
                            title: Text(S.of(context).client),
                            children: branchClients
                                .map((cl) => ListTile(
                                      leading: const Icon(Icons.person_outline),
                                      title: Text(cl.info.name),
                                      subtitle: Text(cl.info.email),
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => UserInfoScreen(
                                              userId: cl.info.id),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }

    if (sections.isEmpty) {
      return const Center(child: Text('لا توجد بيانات')); // No data
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: sections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => sections[i],
    );
  }
}
