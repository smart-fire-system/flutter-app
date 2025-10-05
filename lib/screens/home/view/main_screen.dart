import 'package:fire_alarm_system/screens/home/view/home_screen.dart';
import 'package:fire_alarm_system/widgets/cards.dart';
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(
        title: 'Fire Alarm System',
        leading: Icon(Icons.home),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo/1.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Large featured card - Users
            LargeCard(
              icon: Icons.bar_chart_rounded,
              title: 'System Monitoring & Control',
              subtitle: 'View and manage system',
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
              ),
              onTap: () {
                homeScreenKey.currentState!.setCurrentTab(AppTab.system);
              },
            ),

            const SizedBox(height: 16),
            WideCard(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'View and manage profile',
              color: const Color(0xFFEF4444),
              onTap: () => TabNavigator.home.currentState
                  ?.pushNamed('/profile'),
            ),
            const SizedBox(height: 16),

            // Grid of smaller cards
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SmallCard(
                      icon: Icons.article_rounded,
                      title: 'Reports & Contracts',
                      subtitle: 'View and manage reports & contracts',
                      color: const Color(0xFFE11D48),
                      onTap: () {
                        homeScreenKey.currentState!
                            .setCurrentTab(AppTab.reports);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SmallCard(
                      icon: Icons.support_agent_rounded,
                      title: 'Complaints',
                      subtitle: 'View and manage complaints',
                      color: const Color(0xFFF43F5E),
                      onTap: () {
                        homeScreenKey.currentState!
                            .setCurrentTab(AppTab.complaints);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Full width card - Branches
            WideCard(
              icon: Icons.group_rounded,
              title: 'Users & Branches',
              subtitle: 'View and manage users & branches',
              color: const Color(0xFFEF4444),
              onTap: () {
                homeScreenKey.currentState!
                    .setCurrentTab(AppTab.usersAndBranches);
              },
            ),
            const SizedBox(height: 16),
            LargeCard(
              icon: Icons.wifi_off_rounded,
              title: 'Offline Mode',
              subtitle: 'View and manage system in offline mode',
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 165, 161, 161),
                  Color.fromARGB(255, 121, 118, 118)
                ],
              ),
              onTap: () => TabNavigator.home.currentState
                  ?.pushNamed('/offline'),
            ),
          ],
        ),
      ),
    );
  }
}
