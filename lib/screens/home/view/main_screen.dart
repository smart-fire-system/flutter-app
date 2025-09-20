import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _quickActionsController = ScrollController();
  final ScrollController _contractsController = ScrollController();

  @override
  void dispose() {
    _quickActionsController.dispose();
    _contractsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.wifi_off, color: Colors.white),
                title: const Text('Offline Control', style: TextStyle(color: Colors.white),),
                subtitle: const Text('Tap to control your system locally without internet', style: TextStyle(color: Colors.white),),
                onTap: () => TabNavigator.home.currentState?.pushNamed('/offline'),
                tileColor: CustomStyle.redDark,
              ),
              const SizedBox(height: 24),
              Text(
                'Quick Actions',
                style: CustomStyle.largeText25B,
              ),
              const SizedBox(height: 12),
              Scrollbar(
                controller: _quickActionsController,
                thumbVisibility: true,
                interactive: true,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: _quickActionsController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ActionCard(
                        icon: Icons.apartment,
                        title: S.of(context).companies,
                        subtitle: S.of(context).companiesAndBranches,
                        onTap: () => TabNavigator.home.currentState
                            ?.pushNamed('/companies'),
                      ),
                      const SizedBox(width: 12),
                      _ActionCard(
                        icon: Icons.business,
                        title: S.of(context).branches,
                        subtitle: S.of(context).companiesAndBranches,
                        onTap: () => TabNavigator.home.currentState
                            ?.pushNamed('/branches'),
                      ),
                      const SizedBox(width: 12),
                      _ActionCard(
                        icon: Icons.group,
                        title: S.of(context).users,
                        subtitle: S.of(context).usersDescription,
                        onTap: () =>
                            TabNavigator.home.currentState?.pushNamed('/users'),
                      ),
                      const SizedBox(width: 12),
                      _ActionCard(
                        icon: Icons.group,
                        title: S.of(context).users,
                        subtitle: S.of(context).usersDescription,
                        onTap: () =>
                            TabNavigator.home.currentState?.pushNamed('/users-diagram'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Contracts',
                style: CustomStyle.largeText25B,
              ),
              const SizedBox(height: 12),
              Scrollbar(
                controller: _contractsController,
                thumbVisibility: true,
                interactive: true,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: _contractsController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ActionCard(
                        icon: Icons.assignment_turned_in,
                        title: 'View Contracts',
                        subtitle: 'View all contracts',
                        onTap: () => TabNavigator.home.currentState
                            ?.pushNamed('/reports/contracts'),
                      ),
                      const SizedBox(width: 12),
                      _ActionCard(
                        icon: Icons.assignment_turned_in,
                        title: 'New Contract',
                        subtitle: 'Add new contract',
                        onTap: () => TabNavigator.home.currentState
                            ?.pushNamed('/reports/new-contract'),
                      ),
                      const SizedBox(width: 12),
                      _ActionCard(
                        icon: Icons.category,
                        title: 'Contract Components',
                        subtitle: 'Configure system categories',
                        onTap: () => TabNavigator.home.currentState
                            ?.pushNamed('/reports/contract-components'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x1AF44336),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, color: CustomStyle.redDark, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: CustomStyle.largeTextB,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: CustomStyle.mediumText,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
