import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/models/user.dart';

enum AccessDeniedType { accountNeedsVerification, noRoleForUser }

class CustomAccessDenied extends StatelessWidget {
  final UserInfo user;
  final AccessDeniedType type;
  final void Function()? onLogoutClick;
  final void Function()? onResendClick;
  const CustomAccessDenied({
    super.key,
    required this.user,
    required this.type,
    this.onLogoutClick,
    this.onResendClick,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == AccessDeniedType.accountNeedsVerification
              ? l10n.account_not_verified_title
              : l10n.access_denied_title,
          style: CustomStyle.appBarText,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        user.name,
                        style: CustomStyle.mediumText,
                      ),
                      subtitle: Text(user.email, style: CustomStyle.smallText),
                      leading: Image.asset(
                        'assets/images/access-denied.png',
                        fit: BoxFit.contain,
                        width: 50,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      type == AccessDeniedType.accountNeedsVerification
                          ? l10n.account_not_verified_message
                          : l10n.access_denied_message,
                      style: CustomStyle.largeTextB,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (onLogoutClick != null) {
                          onLogoutClick!();
                        }
                      },
                      style: CustomStyle.normalButton,
                      child: Text(
                        l10n.logout,
                        style: CustomStyle.normalButtonText,
                      ),
                    ),
                  ),
                  if (type ==
                      AccessDeniedType.accountNeedsVerification)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (onResendClick != null) {
                            onResendClick!();
                          }
                        },
                        style: CustomStyle.normalButton,
                        child: Text(
                          l10n.resend_verification_email,
                          style: CustomStyle.normalButtonText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
