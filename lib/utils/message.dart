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
      default:
        return 'This is message';
    }
  }
}
