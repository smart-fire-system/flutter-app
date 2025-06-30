import 'package:fire_alarm_system/generated/l10n.dart';
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
    switch (id) {
      case AppMessageId.resetPasswordEmailSent:
        return S.of(context).reset_email_sent;
      case AppMessageId.emailConfirmationSent:
        return S.of(context).confirmEmailSent;
      case AppMessageId.profileInfoUpdated:
        return S.of(context).info_updated;
      default:
        return 'This is message';
    }
  }
}
