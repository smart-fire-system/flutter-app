import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocalizationUtil {
  static const String _languageCodeKey = 'languageCode';

  static Future<void> saveLanguagePreference(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
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

  static Future<Locale> initializeLanguage() async {
    Locale? savedLocale = await loadLanguagePreference();
    return savedLocale ?? detectDeviceLanguage();
  }

  static Future<Locale> changeLanguage(Locale locale) async {
    await saveLanguagePreference(locale);
    return locale;
  }

  static void showEditLanguageDialog(
      BuildContext context, Function(Locale) onLanguageChange) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          backgroundColor: Colors.white, // Custom background color
          title: Row(
            children: [
                const FaIcon(FontAwesomeIcons.list, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(
                S.of(context).select_language,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Custom title style
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.globe, color: Colors.blueAccent),
                title: const Text('English'),
                onTap: () {
                  onLanguageChange(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.globe, color: Colors.blueAccent),
                title: const Text('العربية'),
                onTap: () {
                  onLanguageChange(const Locale('ar'));
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
