import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DataValidator {
  bool isValidEmail(String email) {
    if (email.isEmpty) {
      return false;
    }
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String password, String confirmPassword) {
    return password == confirmPassword && password.length >= 6;
  }

  static String? validateEmail(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.enter_email;
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return l10n.valid_email;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.enter_password;
    } else if (value.length < 6) {
      return l10n.password_length;
    }
    return null;
  }

  static String? validateConfirmPassword(BuildContext context, String? value,
      TextEditingController passwordController) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.confirm_password;
    } else if (value != passwordController.text) {
      return l10n.password_mismatch;
    }
    return null;
  }

  static String? validateName(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.enter_name;
    }
    return null;
  }

  static String? validatePhone(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.enter_phone_number;
    }
    String pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return l10n.valid_phone_number;
    }
    return null;
  }
}
