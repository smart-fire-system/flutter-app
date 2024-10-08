import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomAlert {
  static Future<bool?> showError(BuildContext context, String message) async {
    return await Alert(
      context: context,
      type: AlertType.error,
      title: S.of(context).error,
      desc: message,
      style: AlertStyle(
        titleStyle: CustomStyle.largeTextB,
        descStyle: CustomStyle.mediumText,
        animationType: AnimationType.grow,
      ),
      buttons: [
        DialogButton(
          child: Text(S.of(context).ok, style: CustomStyle.normalButtonText),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }

  static Future<void> showInfo(BuildContext context, String message) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Alert(
        context: context,
        type: AlertType.info,
        desc: message,
        style: AlertStyle(
          titleStyle: CustomStyle.largeTextB,
          descStyle: CustomStyle.mediumText,
          animationType: AnimationType.grow,
        ),
        buttons: [
          DialogButton(
            child: Text(S.of(context).ok, style: CustomStyle.normalButtonText),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    });
  }

  static Future<void> showWarning(BuildContext context, String message) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Alert(
        context: context,
        type: AlertType.warning,
        desc: message,
        style: AlertStyle(
          titleStyle: CustomStyle.largeTextB,
          descStyle: CustomStyle.mediumText,
          animationType: AnimationType.grow,
        ),
        buttons: [
          DialogButton(
            child: Text(S.of(context).ok, style: CustomStyle.normalButtonText),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    });
  }

  static Future<bool?> showSuccess(BuildContext context, String message) async {
    return await Alert(
      context: context,
      type: AlertType.success,
      desc: message,
      style: AlertStyle(
        titleStyle: CustomStyle.largeTextB,
        descStyle: CustomStyle.mediumText,
        animationType: AnimationType.grow,
      ),
      buttons: [
        DialogButton(
          child: Text(S.of(context).ok, style: CustomStyle.normalButtonText),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }
}
