import 'package:fire_alarm_system/screens/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/screens/complaints/view/view.dart';
import 'package:fire_alarm_system/screens/profile/view/view.dart';
import 'package:fire_alarm_system/screens/reports/view/view.dart';
import 'package:fire_alarm_system/screens/settings/view/view.dart';
import 'package:fire_alarm_system/screens/system/view/view.dart';

enum Screen {
  system,
  reports,
  profile,
  complaints,
  settigns, 
}

class TabNavigator extends StatelessWidget {
  final Screen screen;
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
      case Screen.system:
        navigatorKey = system;
        break;
      case Screen.reports:
        navigatorKey = reports;
        break;
      case Screen.profile:
        navigatorKey = profile;
        break;
      case Screen.complaints:
        navigatorKey = complaints;
        break;
      case Screen.settigns:
        navigatorKey = settings;
        break;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (popInvocation, x) async {
        if (screen == homeScreenKey.currentState!.getCurrentScreen())
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
            case '/system':
              page = SystemScreen();
              break;
            case '/reports':
              page = ReportsScreen();
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

  Widget _buildMainScreen(Screen screen) {
    switch (screen) {
      case Screen.system:
        return const SystemScreen();
      case Screen.reports:
        return const ReportsScreen();
      case Screen.profile:
        return const ProfileScreen();
      case Screen.complaints:
        return const ComplaintsScreen();
      case Screen.settigns:
        return const SettingsScreen();
    }
  }
}
