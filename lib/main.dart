import 'package:fire_alarm_system/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/models/user_auth.dart';

import 'package:fire_alarm_system/screens/home/view/view.dart';
import 'package:fire_alarm_system/screens/login/view/view.dart';
import 'package:fire_alarm_system/screens/signup/view/view.dart';
import 'package:fire_alarm_system/screens/users/view/view.dart';

import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/login/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/signup/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/admins/bloc.dart';

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
  Future<UserAuth>? _authFuture;
  final _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _authFuture = _authRepository.initAuth();
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
    return FutureBuilder<UserAuth>(
      future: _authFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoading(noText: true);
        } else if (snapshot.hasData) {
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthRepository>(
                  create: (_) => _authRepository),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (_) => LoginBloc(authRepository: _authRepository)),
                BlocProvider(
                    create: (_) => SignUpBloc(authRepository: _authRepository)),
                BlocProvider(
                    create: (_) => HomeBloc(authRepository: _authRepository)),
                BlocProvider(
                    create: (_) => AdminsBloc(authRepository: _authRepository)),
              ],
              child: MaterialApp(
                title: 'Smart Fire System',
                builder: EasyLoading.init(),
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
                  '/welcome': (context) => const WelcomeScreen(),
                  '/home': (context) => const HomeScreen(),
                  '/login': (context) => const LoginScreen(),
                  '/signup': (context) => const SignUpScreen(),
                  '/admins': (context) => const AdminsScreen(),
                },
                initialRoute:
                    (snapshot.data?.authStatus == AuthStatus.notAuthenticated)
                        ? '/welcome'
                        : '/home',
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
