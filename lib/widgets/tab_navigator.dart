import 'package:fire_alarm_system/screens/profile/view/update_profile.dart';
import 'package:fire_alarm_system/screens/system/view/master_details_screen.dart';
import 'package:fire_alarm_system/screens/users/view/update_user.dart';
import 'package:fire_alarm_system/screens/users/view/users_screen.dart';
import 'package:fire_alarm_system/screens/users/view/view_user.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/screens/home/view/view.dart';
import 'package:fire_alarm_system/screens/branches/view/view.dart';
import 'package:fire_alarm_system/screens/complaints/view/view.dart';
import 'package:fire_alarm_system/screens/profile/view/view.dart';
import 'package:fire_alarm_system/screens/reports/view/view.dart';
import 'package:fire_alarm_system/screens/system/view/view.dart';

enum AppTab {
  system,
  reports,
  home,
  complaints,
  profile,
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
      case AppTab.home:
        navigatorKey = settings;
        break;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (popInvocation, x) async {
        if (screen == homeScreenKey.currentState!.getCurrentTab()) {
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
            case '/branch/details':
              page = BranchDetailsScreen(
                  branchId: routeSettings.arguments as String);
              break;
            case '/branch/edit':
              page =
                  EditBranchScreen(branchId: routeSettings.arguments as String);
              break;
            case '/branch/add':
              page = const AddBranchScreen();
              break;
            case '/companies':
              page = const CompaniesScreen();
              break;
            case '/company/details':
              page = CompanyDetailsScreen(
                  companyId: routeSettings.arguments as String);
              break;
            case '/company/edit':
              page = EditCompanyScreen(
                  companyId: routeSettings.arguments as String);
              break;
            case '/company/add':
              page = const AddCompanyScreen();
              break;
            case '/users':
              page = const UsersScreen();
              break;
            case '/user/view':
              page = UserInfoScreen(userId: routeSettings.arguments as String);
              break;
            case '/user/update':
              page =
                  UpdateUserScreen(userId: routeSettings.arguments as String);
              break;
            case '/profile/update':
              page = const UpdateProfileScreen();
              break;
            case '/master/details':
              page =
                  MasterDetailsScreen(masterId: routeSettings.arguments as int);
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
      case AppTab.home:
        return const MainScreen();
    }
  }
}
