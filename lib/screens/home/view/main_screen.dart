import 'package:fire_alarm_system/screens/home/view/home_screen.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
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
      appBar: CustomAppBar(
        title: S.of(context).app_name,
        leading: const Icon(Icons.home),
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
              title: S.of(context).system_monitoring_control,
              subtitle: S.of(context).system_monitoring_card_subtitle,
              titleColor: Colors.white,
              subtitleColor: Colors.white,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CustomStyle.redDark, CustomStyle.redDark],
              ),
              onTap: () {
                homeScreenKey.currentState!.setCurrentTab(AppTab.system);
              },
            ),

            const SizedBox(height: 16),
            WideCard(
                icon: Icons.person,
                title: S.of(context).profile,
                subtitle: S.of(context).profile_subtitle,
                color: const Color(0xFFEF4444),
                onTap: () =>
                    homeScreenKey.currentState!.setCurrentTab(AppTab.profile)),
            const SizedBox(height: 16),
            WideCard(
                icon: Icons.assignment,
                title: S.of(context).reports_contracts_title,
                subtitle: S.of(context).reports_contracts_subtitle,
                color: const Color(0xFFEF4444),
                onTap: () =>
                    homeScreenKey.currentState!.setCurrentTab(AppTab.reports)),
            const SizedBox(height: 16),

            // Full width card - Branches
            WideCard(
              icon: Icons.group_rounded,
              title: S.of(context).users_and_branches,
              subtitle: S.of(context).users_and_branches_subtitle,
              color: const Color(0xFFEF4444),
              onTap: () {
                homeScreenKey.currentState!
                    .setCurrentTab(AppTab.usersAndBranches);
              },
            ),
            const SizedBox(height: 16),
            LargeCard(
              icon: Icons.wifi_off_rounded,
              title: S.of(context).offline_mode,
              subtitle: S.of(context).offline_mode_subtitle,
              titleColor: Colors.white,
              subtitleColor: Colors.white,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 165, 161, 161),
                  Color.fromARGB(255, 121, 118, 118)
                ],
              ),
              onTap: () =>
                  TabNavigator.home.currentState?.pushNamed('/offline'),
            ),
          ],
        ),
      ),
    );
  }
}
