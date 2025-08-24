import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Main'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            /**********************************************/
            /*********** Companies and Branches ***********/
            /**********************************************/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(
                  Icons.location_city,
                  color: CustomStyle.redDark,
                ),
                title: Text(
                  S.of(context).companiesAndBranches,
                  style: CustomStyle.largeText25B,
                ),
                subtitle: Text(
                  S.of(context).companiesAndBranchesDescription,
                  style: CustomStyle.mediumText,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  S.of(context).companies,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_1,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  TabNavigator.home.currentState?.pushNamed('/companies');
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  S.of(context).branches,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_2,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  TabNavigator.home.currentState?.pushNamed('/branches');
                },
              ),
            ),
            /**********************************************/
            /******************** Users *******************/
            /**********************************************/
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: CustomStyle.greyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(
                  Icons.group,
                  color: CustomStyle.redDark,
                ),
                title: Text(
                  S.of(context).users,
                  style: CustomStyle.largeText25B,
                ),
                subtitle: Text(
                  S.of(context).usersDescription,
                  style: CustomStyle.mediumText,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  S.of(context).users,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_1,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  TabNavigator.home.currentState?.pushNamed('/users');
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: CustomStyle.greyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(
                  Icons.settings_applications,
                  color: CustomStyle.redDark,
                ),
                title: Text(
                  'Contracts Settings',
                  style: CustomStyle.largeText25B,
                ),
                subtitle: Text(
                  'Manage contract-related configuration',
                  style: CustomStyle.mediumText,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  'System Types',
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_1,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  TabNavigator.home.currentState
                      ?.pushNamed('/reports/system-types');
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  'Maintenance Plans',
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_2,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
