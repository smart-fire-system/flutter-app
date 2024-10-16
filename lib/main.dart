import 'package:fire_alarm_system/firebase_options.dart';
import 'package:fire_alarm_system/widgets/no_internet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/screens/home/view/view.dart';
import 'package:fire_alarm_system/screens/welcome/view/view.dart';
import 'package:fire_alarm_system/screens/login/view/view.dart';
import 'package:fire_alarm_system/screens/signup/view/view.dart';
import 'package:fire_alarm_system/screens/users/view/view.dart';
import 'package:fire_alarm_system/screens/profile/view/view.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/welcome/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/login/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/signup/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/admins/bloc.dart';
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
  late Future<bool> _internetConnectionFuture;

  @override
  void initState() {
    super.initState();
    _internetConnectionFuture = checkInternetConnection();
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

  Future<bool> checkInternetConnection() async {
    if (kIsWeb) {
      return true;
    }
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    try {
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
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
              create: (_) => LoginBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => SignUpBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => WelcomeBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => HomeBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => AdminsBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (_) => ProfileBloc(authRepository: _authRepository)),
        ],
        child: MaterialApp(
          title: 'Fire Alarm System',
          color: Colors.white,
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
          builder: (context, child) {
            return FutureBuilder<bool>(
              future: _internetConnectionFuture,
              builder: (context, internetSnapshot) {
                if (internetSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CustomLoading();
                }

                if (internetSnapshot.hasError || !internetSnapshot.data!) {
                  return const CustomNoInternet();
                }

                return StreamBuilder<String?>(
                  stream: _authRepository.authStateChanges,
                  builder: (context, authSnapshot) {
                    if (authSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CustomLoading();
                    } else if (authSnapshot.hasError) {
                      return const CustomNoInternet();
                    } else if (authSnapshot.hasData) {
                      if (authSnapshot.data != "") {
                        return const CustomNoInternet();
                      }
                      return child ?? const CustomLoading();
                    } else {
                      return const CustomLoading();
                    }
                  },
                );
              },
            );
          },
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/admins': (context) => const AdminsScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
          initialRoute: '/welcome',
        ),
      ),
    );
  }
}
