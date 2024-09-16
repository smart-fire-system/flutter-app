import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'generated/l10n.dart';
import 'screens/sign_up_screen.dart';
import 'screens/login_screen.dart';
import 'utils/localization_util.dart';

void main() {
  runApp(const FireAlarmApp());
}

class FireAlarmApp extends StatefulWidget {
  const FireAlarmApp({super.key});
  @override
  State<FireAlarmApp> createState() => _FireAlarmAppState();
}

class _FireAlarmAppState extends State<FireAlarmApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadInitialLanguage();
  }

  Future<void> _loadInitialLanguage() async {
    Locale locale = await LocalizationUtil.initializeLanguage();
    setState(() {
      _locale = locale;
    });
  }

  Future<void> _changeLanguage(Locale locale) async {
    Locale updatedLocale = await LocalizationUtil.changeLanguage(locale);
    setState(() {
      _locale = updatedLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Fire System',

      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        S.delegate,
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      localeResolutionCallback: (locale, supportedLocales) {
        if (_locale != null) {
          return _locale;
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      routes: {
        '/login': (context) =>
            LoginScreen(onLanguageChange: _changeLanguage),
        '/signup': (context) =>
            SignUpScreen(onLanguageChange: _changeLanguage),
        //'/signup': (context) => const SignUpScreen(), // Add the signup route
      },

      initialRoute: '/login',
    );
  }
}
