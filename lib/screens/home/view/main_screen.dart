import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/screens/home/view/home_screen.dart';
import 'package:fire_alarm_system/screens/home/view/about_app_developer_screen.dart';
import 'package:fire_alarm_system/screens/notifications/view/notifications_screen.dart';
import 'package:fire_alarm_system/utils/app_version.dart';
import 'package:fire_alarm_system/widgets/app_shimmer.dart';
import 'package:fire_alarm_system/widgets/cards.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final AnimationController _logoShimmerController;

  @override
  void initState() {
    super.initState();
    _logoShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _logoShimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: l10n.app_name,
        leading: const Icon(Icons.home),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _logoShimmerController,
              builder: (context, _) {
                return Hero(
                  tag: 'appLogoHero',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AppShimmer(
                      progress: _logoShimmerController.value,
                      child: Image.asset(
                        'assets/images/logo/1.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: QuickNavButton(
                    icon: Icons.bar_chart_rounded,
                    label: l10n.system,
                    onTap: () => homeScreenKey.currentState!
                        .setCurrentTab(AppTab.system),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickNavButton(
                    icon: Icons.article_rounded,
                    label: l10n.reports_contracts_title,
                    onTap: () => homeScreenKey.currentState!
                        .setCurrentTab(AppTab.reports),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickNavButton(
                    icon: Icons.group_rounded,
                    label: l10n.users_and_branches,
                    onTap: () => homeScreenKey.currentState!
                        .setCurrentTab(AppTab.usersAndBranches),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickNavButton(
                    icon: Icons.person_rounded,
                    label: l10n.profile,
                    onTap: () => homeScreenKey.currentState!
                        .setCurrentTab(AppTab.profile),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            WideCard(
              icon: Icons.qr_code_scanner,
              title: l10n.signatures_title,
              subtitle: l10n.signatures_enter_or_scan_hint,
              color: const Color(0xFFF43F5E),
              onTap: () => TabNavigator.home.currentState?.pushNamed(
                '/signatures',
              ),
            ),
            const SizedBox(height: 16),
            WideCard(
              icon: Icons.notifications_rounded,
              title: l10n.notifications,
              subtitle: l10n.notifications_subtitle,
              color: const Color(0xFFEF4444),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsScreen()));
              },
            ),
            const SizedBox(height: 16),
            LargeCard(
              icon: Icons.wifi_off_rounded,
              title: l10n.offline_mode,
              subtitle: l10n.offline_mode_subtitle,
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
            const SizedBox(height: 16),
            WideCard(
              icon: Icons.info_outline_rounded,
              title: l10n.about_app_and_developer,
              subtitle: l10n.about_app_and_developer_subtitle,
              color: const Color(0xFF3B82F6),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAppDeveloperScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
                      ? androidAppVersion
                      : iosAppVersion,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
