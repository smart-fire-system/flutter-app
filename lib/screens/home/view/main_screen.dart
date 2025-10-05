import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Home'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          const padding = 16.0;
          const spacing = 12.0;
          // Calculate row height accounting for padding and spacing
          final rowHeight =
              (availableHeight - (2 * padding) - (3 * spacing)) / 4;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  // Row 1: 2 cards (Offline, Profile)
                  SizedBox(
                    height: rowHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: _MainCard(
                            icon: Icons.wifi_off,
                            title: 'Offline',
                            subtitle: 'Control system locally',
                            backgroundColor: const Color(0xFFDC2626),
                            onTap: () => TabNavigator.home.currentState
                                ?.pushNamed('/offline'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MainCard(
                            icon: Icons.person,
                            title: 'Profile',
                            subtitle: 'Manage your profile',
                            backgroundColor: const Color(0xFFE11D48),
                            onTap: () => TabNavigator.home.currentState
                                ?.pushNamed('/profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: spacing),
                  // Row 2: 1 card (System)
                  SizedBox(
                    height: rowHeight,
                    child: _MainCard(
                      icon: Icons.settings_system_daydream,
                      title: 'System',
                      subtitle: 'System configuration and settings',
                      backgroundColor: const Color(0xFFF43F5E),
                      onTap: () =>
                          TabNavigator.home.currentState?.pushNamed('/system'),
                    ),
                  ),
                  const SizedBox(height: spacing),
                  // Row 3: 2 cards (Reports, Complaints)
                  SizedBox(
                    height: rowHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: _MainCard(
                            icon: Icons.description,
                            title: 'Reports',
                            subtitle: 'View all reports',
                            backgroundColor: const Color(0xFFEF4444),
                            onTap: () => TabNavigator.home.currentState
                                ?.pushNamed('/reports'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MainCard(
                            icon: Icons.report_problem,
                            title: 'Complaints',
                            subtitle: 'Manage complaints',
                            backgroundColor: const Color(0xFFB91C1C),
                            onTap: () => TabNavigator.home.currentState
                                ?.pushNamed('/complaints'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: spacing),
                  // Row 4: 1 card (Users and Branches)
                  SizedBox(
                    height: rowHeight,
                    child: _MainCard(
                      icon: Icons.group,
                      title: 'Users and Branches',
                      subtitle: 'Manage users and branches',
                      backgroundColor: const Color(0xFFFB7185),
                      onTap: () => TabNavigator.home.currentState
                          ?.pushNamed('/users-branches'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _MainCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor.withValues(alpha: 0.08),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: backgroundColor.withValues(alpha: 0.1),
          highlightColor: backgroundColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Title in same row at top
                Row(
                  children: [
                    // Icon with colored background
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: backgroundColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        icon,
                        color: backgroundColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Subtitle centered vertically
                Center(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
