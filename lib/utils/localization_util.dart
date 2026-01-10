import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'dart:async';

class LocalizationUtil {
  static Locale myLocale = const Locale('en');
  static dynamic Function(Locale)? changeMainLanguageCallback;
  static const String _languageCodeKey = 'languageCode';

  static final StreamController<Locale> _languageChangedController =
      StreamController<Locale>.broadcast();

  static Stream<Locale> get languageChangedStream =>
      _languageChangedController.stream;

  static String get languageCode => myLocale.languageCode;

  static void setChangeLanguageCallback(dynamic Function(Locale) callback) {
    changeMainLanguageCallback = callback;
  }

  static Future<Locale> initializeLanguage() async {
    Locale? savedLocale = await loadLanguagePreference();
    myLocale = savedLocale ?? detectDeviceLanguage();
    _languageChangedController.add(myLocale);
    try {
      FirebaseAuth.instance.setLanguageCode(myLocale.languageCode);
    } catch (_) {}
    return myLocale;
  }

  static Future<void> changeLanguage(Locale locale) async {
    await saveLanguagePreference(locale);
    myLocale = locale;
    _languageChangedController.add(myLocale);
    changeMainLanguageCallback?.call(locale);
    try {
      FirebaseAuth.instance.setLanguageCode(myLocale.languageCode);
    } catch (_) {}
  }

  static Future<void> dispose() async {
    await _languageChangedController.close();
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          backgroundColor: Colors.white, // Custom background color
          title: Text(
            l10n.select_language,
            style: CustomStyle.largeTextB,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language, color: Colors.blueAccent),
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
                leading: const Icon(Icons.language, color: Colors.blueAccent),
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
                l10n.cancel,
                style: CustomStyle.smallText,
              ),
            ),
          ],
        );
      },
    );
  }
}
