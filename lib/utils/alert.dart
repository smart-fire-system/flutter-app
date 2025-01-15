import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:flutter/material.dart';

class CustomAlertConfirmationButton {
  final String title;
  final int value;
  final Color backgroundColor;
  final Color textColor;
  CustomAlertConfirmationButton({
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
  });
}

class CustomAlert {
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    String? subtitle,
    String? buttonText,
    bool barrierDismissible = true,
    bool canPop = true,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canPop,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width * 0.8
                  : 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height < 800
                    ? MediaQuery.of(context).size.height * 0.7
                    : 400,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Image.asset(
                    'assets/gif/success.gif',
                    height: 75,
                  ),
                  Center(
                    child: Text(
                      title,
                      style: CustomStyle.largeText25B,
                    ),
                  ),
                  if (subtitle != null)
                    Center(
                      child: Text(
                        subtitle,
                        style: CustomStyle.largeText,
                      ),
                    ),
                  CustomBasicButton(
                    label: buttonText ?? S.of(context).ok,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<int?> showConfirmation({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<CustomAlertConfirmationButton> buttons,
    bool barrierDismissible = true,
    bool canPop = true,
  }) async {
    int? pressedValue;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canPop,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width * 0.8
                  : 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height < 800
                    ? MediaQuery.of(context).size.height * 0.7
                    : 400,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Image.asset(
                    'assets/gif/warning.gif',
                    height: 75,
                  ),
                  Center(
                    child: Text(
                      title,
                      style: CustomStyle.largeText25B,
                    ),
                  ),
                  if (subtitle != null)
                    Center(
                      child: Text(
                        subtitle,
                        style: CustomStyle.largeText,
                      ),
                    ),
                  ...List.generate(buttons.length, (index) {
                    return CustomNormalButton(
                      label: buttons[index].title,
                      backgroundColor: buttons[index].backgroundColor,
                      textColor: buttons[index].textColor,
                      onPressed: () {
                        pressedValue = buttons[index].value;
                        Navigator.of(context).pop();
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
    return pressedValue;
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    String? subtitle,
    String? buttonText,
    bool barrierDismissible = true,
    bool canPop = true,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canPop,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width * 0.8
                  : 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height < 800
                    ? MediaQuery.of(context).size.height * 0.7
                    : 400,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Image.asset(
                    'assets/gif/fail.gif',
                    height: 75,
                  ),
                  Center(
                    child: Text(
                      title,
                      style: CustomStyle.largeText25B,
                    ),
                  ),
                  if (subtitle != null)
                    Center(
                      child: Text(
                        subtitle,
                        style: CustomStyle.largeText,
                      ),
                    ),
                  CustomBasicButton(
                    label: buttonText ?? S.of(context).ok,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
