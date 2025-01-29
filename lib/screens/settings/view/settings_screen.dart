import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settings),
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
                  TabNavigator.settings.currentState?.pushNamed('/companies');
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
                  TabNavigator.settings.currentState?.pushNamed('/branches');
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
                  S.of(context).admins,
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
                  TabNavigator.settings.currentState?.pushNamed('/admins');
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  S.of(context).companyManagers,
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
                  TabNavigator.settings.currentState?.pushNamed('/companyManagers');
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  S.of(context).branchManagers,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_3,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  TabNavigator.settings.currentState?.pushNamed('/branchManagers');
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  S.of(context).employees,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_4,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  TabNavigator.settings.currentState?.pushNamed('/employees');
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
              child: ListTile(
                title: Text(
                  S.of(context).clients,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.filter_5,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  TabNavigator.settings.currentState?.pushNamed('/clients');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
