import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/screens/branches/view/branches_details.dart';
import 'package:fire_alarm_system/screens/branches/view/branches_edit.dart';
import 'package:fire_alarm_system/screens/branches/view/branches_screen.dart';
import 'package:fire_alarm_system/screens/home/view/home_screen.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/screens/complaints/view/view.dart';
import 'package:fire_alarm_system/screens/profile/view/view.dart';
import 'package:fire_alarm_system/screens/reports/view/view.dart';
import 'package:fire_alarm_system/screens/settings/view/view.dart';
import 'package:fire_alarm_system/screens/system/view/view.dart';

enum AppTab {
  system,
  reports,
  profile,
  complaints,
  settigns, 
}

class TabNavigator extends StatelessWidget {
  final AppTab screen;
  const TabNavigator({super.key, required this.screen});

  static final GlobalKey<NavigatorState> system = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> reports = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profile = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> complaints =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settings = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = system;
    switch (screen) {
      case AppTab.system:
        navigatorKey = system;
        break;
      case AppTab.reports:
        navigatorKey = reports;
        break;
      case AppTab.profile:
        navigatorKey = profile;
        break;
      case AppTab.complaints:
        navigatorKey = complaints;
        break;
      case AppTab.settigns:
        navigatorKey = settings;
        break;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (popInvocation, x) async {
        if (screen == homeScreenKey.currentState!.getCurrentTab())
        {
          final didPopNested =
              await navigatorKey.currentState?.maybePop() ?? false;
          if (!didPopNested) {
            homeScreenKey.currentState!.goBack();
          }
        }
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (routeSettings) {
          Widget page;
          switch (routeSettings.name) {
            case '/':
              page = _buildMainScreen(screen);
              break;
            case '/branches':
              page = const BranchesScreen();
              break;
            case '/branches/details':
              page = BranchDetails(branchId: routeSettings.arguments as String);
              break;
            case '/branches/edit':
              page = EditBranchScreen(branchId: routeSettings.arguments as String);
              break;
            case '/companies':
              page = const CustomLoading();
              break;
            default:
              page = Scaffold(
                body:
                    Center(child: Text('Unknown route: ${routeSettings.name}')),
              );
              break;
          }

          return MaterialPageRoute(
            builder: (_) => page,
            settings: routeSettings,
          );
        },
      ),
    );
  }

  Widget _buildMainScreen(AppTab screen) {
    switch (screen) {
      case AppTab.system:
        return const SystemScreen();
      case AppTab.reports:
        return const ReportsScreen();
      case AppTab.profile:
        return const ProfileScreen();
      case AppTab.complaints:
        return const ComplaintsScreen();
      case AppTab.settigns:
        return const SettingsScreen();
    }
  }
}
