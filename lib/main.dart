import 'package:fire_alarm_system/firebase_options.dart';
import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/screens/home/view/view.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FireAlarmApp());
}

class FireAlarmApp extends StatefulWidget {
  const FireAlarmApp({super.key});
  @override
  State<FireAlarmApp> createState() => _FireAlarmAppState();
}

class _FireAlarmAppState extends State<FireAlarmApp> {
  Locale? _locale;
  final _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    LocalizationUtil.setChangeLanguageCallback(setLocale);
    _loadInitialLanguage();
  }

  Future<void> _loadInitialLanguage() async {
    Locale? locale = await LocalizationUtil.initializeLanguage();
    setState(() {
      _locale = locale;
    });
  }

  void setLocale(Locale? updatedLocale) {
    setState(() {
      _locale = updatedLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => _authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => HomeBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => UsersBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => ProfileBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => BranchesBloc(authRepository: _authRepository)),
        ],
        child: MaterialApp(
          title: 'Fire Alarm System',
          theme: ThemeData(
            primaryColor: CustomStyle.redDark,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.red,
              cardColor: Colors.white,
            ).copyWith(
              secondary: Colors.green, // Secondary color
            ),
            scaffoldBackgroundColor:
                Colors.white, // Set default background to white
          ),
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
            '/': (context) => HomeScreen(
                  key: homeScreenKey,
                ),
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}
