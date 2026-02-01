import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum AppMessageId {
  resetPasswordEmailSent,
  emailConfirmationSent,

  profileInfoUpdated,

  masterAdminAdded,
  masterAdminModified,
  masterAdminDeleted,
  adminAdded,
  adminModified,
  adminDeleted,
  companyManagerAdded,
  companyManagerModified,
  companyManagerDeleted,
  branchManagerAdded,
  branchManagerModified,
  branchManagerDeleted,
  employeeAdded,
  employeeModified,
  employeeDeleted,
  clientAdded,
  clientModified,
  clientDeleted,
  notificationsSubscribed,
  notificationsFailedToSubscribe,
  notificationsUnsubscribed,
  notificationsFailedToUnsubscribe,
}

class AppMessage {
  final AppMessageId id;
  AppMessage({required this.id});
  String getText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case AppMessageId.resetPasswordEmailSent:
        return l10n.reset_email_sent;
      case AppMessageId.emailConfirmationSent:
        return l10n.confirmEmailSent;
      case AppMessageId.profileInfoUpdated:
        return l10n.info_updated;
      case AppMessageId.notificationsSubscribed:
        return l10n.notifications_subscribed;
      case AppMessageId.notificationsFailedToSubscribe:
        return l10n.notifications_failed_to_subscribe;
      case AppMessageId.notificationsUnsubscribed:
        return l10n.notifications_unsubscribed;
      case AppMessageId.notificationsFailedToUnsubscribe:
        return l10n.notifications_failed_to_unsubscribe;
      default:
        return 'This is message';
    }
  }

  MaterialColor getColor() {
    switch (id) {
      case AppMessageId.notificationsFailedToSubscribe:
      case AppMessageId.notificationsFailedToUnsubscribe:
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}
