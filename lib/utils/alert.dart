import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:flutter/material.dart';

class CustomAlert {
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    String? subtitle,
    String? buttonText,
    bool barrierDismissible = true,
    bool canPop = true,
  }) async {
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
                        style: CustomStyle.mediumText,
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

  static Future<void> showWarning({
    required BuildContext context,
    required String title,
    String? subtitle,
    String? buttonText,
    bool barrierDismissible = true,
    bool canPop = true,
  }) async {
    bool isConfirmed = false;
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
                        style: CustomStyle.mediumText,
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

  static Future<void> showError({
    required BuildContext context,
    required String title,
    String? subtitle,
    String? buttonText,
    bool barrierDismissible = true,
    bool canPop = true,
  }) async {
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
                        style: CustomStyle.mediumText,
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

  static BuildContext showLoading({
    required BuildContext context,
    required BuildContext? loadingContext,
    String? title,
    GlobalKey<NavigatorState>? key,
  }) {
    if (loadingContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            loadingContext = context;
            return PopScope(
              canPop: false,
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
                          title ?? S.of(context).wait_while_loading,
                          style: CustomStyle.largeText25B,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
    }
    return loadingContext!;
  }

  static BuildContext? dismissLoading({
    required BuildContext? loadingContext,
  }) {
    if (loadingContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(loadingContext);
      });
    }
    return null;
  }
}
