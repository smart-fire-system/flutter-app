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
  notificationsEnabled,
  notificationsDisabled,
  notificationsPermissionDenied,
  unknownError,
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
      case AppMessageId.notificationsEnabled:
        return l10n.notifications_enabled;
      case AppMessageId.notificationsDisabled:
        return l10n.notifications_disabled;
      case AppMessageId.notificationsPermissionDenied:
        return l10n.notifications_permission_denied;
      case AppMessageId.unknownError:
        return l10n.unknown_error;
      default:
        return 'This is message';
    }
  }

  MaterialColor getColor() {
    switch (id) {
      case AppMessageId.notificationsPermissionDenied:
      case AppMessageId.unknownError:
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}
