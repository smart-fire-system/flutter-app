import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class CustomNotAuthenticated extends StatelessWidget {
  const CustomNotAuthenticated({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.app_name,
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
                    child: Text(
                      l10n.not_authenticated,
                      style: CustomStyle.largeTextB,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/welcome');
                      },
                      style: CustomStyle.normalButton,
                      child: Text(
                        l10n.login,
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
