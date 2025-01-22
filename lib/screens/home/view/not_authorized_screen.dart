import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class NotAuthorizedScreen extends StatelessWidget {
  final String name;
  final String email;
  final String? role;
  final bool isEmailVerified;
  final bool isPhoneAdded;
  final void Function() onRefresh;
  final void Function() onConfirmEmailClick;
  final void Function() onAddPhoneNumberClick;
  final void Function() onLogoutClick;
  const NotAuthorizedScreen({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.isEmailVerified,
    required this.isPhoneAdded,
    required this.onRefresh,
    required this.onConfirmEmailClick,
    required this.onAddPhoneNumberClick,
    required this.onLogoutClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).app_name),
      body: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  S.of(context).stepsToComplete,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(Icons.refresh, size: 40),
                onTap: () {
                  onRefresh();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                child: ListTile(
                  title: Text(
                    name,
                    style: CustomStyle.largeTextB,
                  ),
                  subtitle: Text(
                    email,
                    style: CustomStyle.mediumText,
                  ),
                  leading: const Icon(Icons.person, size: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: isEmailVerified
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 30,
                          ),
                    title: Text(
                      S.of(context).emailVerificationTitle,
                      style: CustomStyle.largeTextB,
                    ),
                    subtitle: Text(
                      isEmailVerified
                          ? S.of(context).emailVerified
                          : S.of(context).emailNotVerified,
                      style: CustomStyle.mediumText,
                    ),
                    onTap: isEmailVerified
                        ? null
                        : () {
                            onConfirmEmailClick();
                          },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: isPhoneAdded
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 30,
                          ),
                    title: Text(
                      S.of(context).phoneNumberTitle,
                      style: CustomStyle.largeTextB,
                    ),
                    subtitle: Text(
                      isPhoneAdded
                          ? S.of(context).phoneNumberAdded
                          : S.of(context).phoneNumberNotAdded,
                      style: CustomStyle.mediumText,
                    ),
                    onTap: isPhoneAdded
                        ? null
                        : () {
                            onAddPhoneNumberClick();
                          },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: role != null
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 30,
                          ),
                    title: Text(
                      S.of(context).accessRoleTitle,
                      style: CustomStyle.largeTextB,
                    ),
                    subtitle: Text(
                      role != null
                          ? '${S.of(context).roleAssigned} [$role]'
                          : S.of(context).roleNotAssigned,
                      style: CustomStyle.mediumText,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    onLogoutClick();
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    S.of(context).logout,
                    style: CustomStyle.normalButtonTextSmallWhite,
                  ),
                  style: CustomStyle.normalButtonRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
