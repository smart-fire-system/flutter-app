import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class LocalizationUtil {
  static Locale myLocale = const Locale('en');
  static dynamic Function(Locale)? changeMainLanguageCallback;
  static const String _languageCodeKey = 'languageCode';

  static void setChangeLanguageCallback(dynamic Function(Locale) callback) {
    changeMainLanguageCallback = callback;
  }

  static Future<Locale> initializeLanguage() async {
    Locale? savedLocale = await loadLanguagePreference();
    myLocale = savedLocale ?? detectDeviceLanguage();
    return myLocale;
  }

  static Future<void> changeLanguage(Locale locale) async {
    await saveLanguagePreference(locale);
    myLocale = locale;
    changeMainLanguageCallback!(locale);
  }

  static Future<Locale?> loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return null;
  }

  static Locale detectDeviceLanguage() {
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    return Locale(deviceLocale.languageCode);
  }

  static Future<void> saveLanguagePreference(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
  }

  static void showEditLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          backgroundColor: Colors.white, // Custom background color
          title: Text(
            S.of(context).select_language,
            style: CustomStyle.largeTextB,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language,
                    color: Colors.blueAccent),
                title: Text(
                  'English',
                  style: CustomStyle.smallText,
                ),
                onTap: () {
                  changeLanguage(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.language,
                    color: Colors.blueAccent),
                title: Text(
                  'العربية',
                  style: CustomStyle.smallText,
                ),
                onTap: () {
                  changeLanguage(const Locale('ar'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                S.of(context).cancel,
                style: CustomStyle.smallText,
              ),
            ),
          ],
        );
      },
    );
  }
}
