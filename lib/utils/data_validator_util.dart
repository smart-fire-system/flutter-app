import 'package:flutter/material.dart';

import 'package:fire_alarm_system/generated/l10n.dart';

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
    if (value == null || value.isEmpty) {
      return S.of(context).enter_email;
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return S.of(context).valid_email;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_password;
    } else if (value.length < 6) {
      return S.of(context).password_length;
    }
    return null;
  }

  static String? validateConfirmPassword(BuildContext context, String? value,
      TextEditingController passwordController) {
    if (value == null || value.isEmpty) {
      return S.of(context).confirm_password;
    } else if (value != passwordController.text) {
      return S.of(context).password_mismatch;
    }
    return null;
  }

  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_name;
    }
    return null;
  }

  static String? validatePhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_phone_number;
    }
    String pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return S.of(context).valid_phone_number;
    }
    return null;
  }
}
