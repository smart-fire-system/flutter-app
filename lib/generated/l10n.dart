// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Smart Fire System`
  String get app_name {
    return Intl.message(
      'Smart Fire System',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email {
    return Intl.message(
      'Email Address',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone {
    return Intl.message(
      'Phone Number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirm_password {
    return Intl.message(
      'Please confirm your password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Sign Up`
  String get don_t_have_an_account {
    return Intl.message(
      'Don\'t have an account? Sign Up',
      name: 'don_t_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Log In`
  String get already_have_an_account {
    return Intl.message(
      'Already have an account? Log In',
      name: 'already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a language`
  String get select_language {
    return Intl.message(
      'Please choose a language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `Log in with Google`
  String get login_with_google {
    return Intl.message(
      'Log in with Google',
      name: 'login_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Log in with Facebook`
  String get login_with_facebook {
    return Intl.message(
      'Log in with Facebook',
      name: 'login_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Google`
  String get signup_with_google {
    return Intl.message(
      'Sign up with Google',
      name: 'signup_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Facebook`
  String get signup_with_facebook {
    return Intl.message(
      'Sign up with Facebook',
      name: 'signup_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get enter_name {
    return Intl.message(
      'Please enter your name',
      name: 'enter_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get enter_phone_number {
    return Intl.message(
      'Please enter your phone number',
      name: 'enter_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get valid_phone_number {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'valid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get enter_password {
    return Intl.message(
      'Please enter your password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get password_length {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'password_length',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get password_mismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'password_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address`
  String get enter_email {
    return Intl.message(
      'Please enter your email address',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get valid_email {
    return Intl.message(
      'Please enter a valid email address',
      name: 'valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while logging you in`
  String get logging_in_progress {
    return Intl.message(
      'Please wait while logging you in',
      name: 'logging_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while creating your account`
  String get signup_in_progress {
    return Intl.message(
      'Please wait while creating your account',
      name: 'signup_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Pleae wait while loading data`
  String get wait_while_loading {
    return Intl.message(
      'Pleae wait while loading data',
      name: 'wait_while_loading',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back! Please log in to your account to continue.`
  String get login_welcome {
    return Intl.message(
      'Welcome back! Please log in to your account to continue.',
      name: 'login_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome! Create a new account to join us and enjoy our services.`
  String get signup_welcome {
    return Intl.message(
      'Welcome! Create a new account to join us and enjoy our services.',
      name: 'signup_welcome',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
