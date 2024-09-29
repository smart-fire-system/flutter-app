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

  /// `Smart Fire Alarm System`
  String get app_name {
    return Intl.message(
      'Smart Fire Alarm System',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Account Not Verified`
  String get account_not_verified_title {
    return Intl.message(
      'Account Not Verified',
      name: 'account_not_verified_title',
      desc: '',
      args: [],
    );
  }

  /// `Your account is not verified. Please check your email for the verification link.`
  String get account_not_verified_message {
    return Intl.message(
      'Your account is not verified. Please check your email for the verification link.',
      name: 'account_not_verified_message',
      desc: '',
      args: [],
    );
  }

  /// `Resend Verification Email`
  String get resend_verification_email {
    return Intl.message(
      'Resend Verification Email',
      name: 'resend_verification_email',
      desc: '',
      args: [],
    );
  }

  /// `Access Denied`
  String get access_denied_title {
    return Intl.message(
      'Access Denied',
      name: 'access_denied_title',
      desc: '',
      args: [],
    );
  }

  /// `You do not have access to this section. Please wait until the system administrators grant you access.`
  String get access_denied_message {
    return Intl.message(
      'You do not have access to this section. Please wait until the system administrators grant you access.',
      name: 'access_denied_message',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
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

  /// `Forgot your password?`
  String get forgot_password {
    return Intl.message(
      'Forgot your password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address to reset your password.`
  String get enter_email_to_reset {
    return Intl.message(
      'Please enter your email address to reset your password.',
      name: 'enter_email_to_reset',
      desc: '',
      args: [],
    );
  }

  /// `A password reset email has been sent. Please check your inbox.`
  String get reset_email_sent {
    return Intl.message(
      'A password reset email has been sent. Please check your inbox.',
      name: 'reset_email_sent',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `View and Control System`
  String get viewAndControlSystem {
    return Intl.message(
      'View and Control System',
      name: 'viewAndControlSystem',
      desc: '',
      args: [],
    );
  }

  /// `Manage and Configure System`
  String get manageAndConfigureSystem {
    return Intl.message(
      'Manage and Configure System',
      name: 'manageAndConfigureSystem',
      desc: '',
      args: [],
    );
  }

  /// `Complaints`
  String get complaints {
    return Intl.message(
      'Complaints',
      name: 'complaints',
      desc: '',
      args: [],
    );
  }

  /// `View Complaints`
  String get viewComplaints {
    return Intl.message(
      'View Complaints',
      name: 'viewComplaints',
      desc: '',
      args: [],
    );
  }

  /// `Submit Complaint`
  String get submitComplaint {
    return Intl.message(
      'Submit Complaint',
      name: 'submitComplaint',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Visits`
  String get visits {
    return Intl.message(
      'Visits',
      name: 'visits',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance Contracts`
  String get maintenanceContracts {
    return Intl.message(
      'Maintenance Contracts',
      name: 'maintenanceContracts',
      desc: '',
      args: [],
    );
  }

  /// `System Status and Faults`
  String get systemStatusAndFaults {
    return Intl.message(
      'System Status and Faults',
      name: 'systemStatusAndFaults',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Admins`
  String get admins {
    return Intl.message(
      'Admins',
      name: 'admins',
      desc: '',
      args: [],
    );
  }

  /// `Regional Managers`
  String get regionalManagers {
    return Intl.message(
      'Regional Managers',
      name: 'regionalManagers',
      desc: '',
      args: [],
    );
  }

  /// `Branch Managers`
  String get branchManagers {
    return Intl.message(
      'Branch Managers',
      name: 'branchManagers',
      desc: '',
      args: [],
    );
  }

  /// `Employees`
  String get employees {
    return Intl.message(
      'Employees',
      name: 'employees',
      desc: '',
      args: [],
    );
  }

  /// `Technicians`
  String get technicans {
    return Intl.message(
      'Technicians',
      name: 'technicans',
      desc: '',
      args: [],
    );
  }

  /// `Clients`
  String get clients {
    return Intl.message(
      'Clients',
      name: 'clients',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `Regional Manager`
  String get regionalManager {
    return Intl.message(
      'Regional Manager',
      name: 'regionalManager',
      desc: '',
      args: [],
    );
  }

  /// `Branch Manager`
  String get branchManager {
    return Intl.message(
      'Branch Manager',
      name: 'branchManager',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get employee {
    return Intl.message(
      'Employee',
      name: 'employee',
      desc: '',
      args: [],
    );
  }

  /// `Technician`
  String get technican {
    return Intl.message(
      'Technician',
      name: 'technican',
      desc: '',
      args: [],
    );
  }

  /// `Client`
  String get client {
    return Intl.message(
      'Client',
      name: 'client',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message(
      'Role',
      name: 'role',
      desc: '',
      args: [],
    );
  }

  /// `No Role`
  String get noRole {
    return Intl.message(
      'No Role',
      name: 'noRole',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `System Monitoring and Control`
  String get system_monitoring_control {
    return Intl.message(
      'System Monitoring and Control',
      name: 'system_monitoring_control',
      desc: '',
      args: [],
    );
  }

  /// `Monitor the current state of each sensor and control sub-units. You can also perform actions like turning devices on or off directly from this interface.`
  String get system_monitoring_description {
    return Intl.message(
      'Monitor the current state of each sensor and control sub-units. You can also perform actions like turning devices on or off directly from this interface.',
      name: 'system_monitoring_description',
      desc: '',
      args: [],
    );
  }

  /// `Show reports for maintenance contracts, visits and system status.`
  String get reportsDescription {
    return Intl.message(
      'Show reports for maintenance contracts, visits and system status.',
      name: 'reportsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Show open compaints or submit new one.`
  String get complaintsDescription {
    return Intl.message(
      'Show open compaints or submit new one.',
      name: 'complaintsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Show and give or remove access from users`
  String get usersDescription {
    return Intl.message(
      'Show and give or remove access from users',
      name: 'usersDescription',
      desc: '',
      args: [],
    );
  }

  /// `Remove User`
  String get deleteUser {
    return Intl.message(
      'Remove User',
      name: 'deleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Modify Access Role`
  String get changeAccessRole {
    return Intl.message(
      'Modify Access Role',
      name: 'changeAccessRole',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to permanently delete this user from the system?`
  String get confirmDeleteUser {
    return Intl.message(
      'Are you sure you want to permanently delete this user from the system?',
      name: 'confirmDeleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to proceed with changing the user's access permissions?`
  String get confirmChangeAccessRole {
    return Intl.message(
      'Do you want to proceed with changing the user\'s access permissions?',
      name: 'confirmChangeAccessRole',
      desc: '',
      args: [],
    );
  }

  /// `User has been successfully deleted from the system.`
  String get userDeletedSuccessMessage {
    return Intl.message(
      'User has been successfully deleted from the system.',
      name: 'userDeletedSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `User's access role has been successfully updated.`
  String get accessRoleChangedSuccessMessage {
    return Intl.message(
      'User\'s access role has been successfully updated.',
      name: 'accessRoleChangedSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add New Admin`
  String get addNewAdmin {
    return Intl.message(
      'Add New Admin',
      name: 'addNewAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Smart Fire Alarm System. Please login or sign up.`
  String get welcome_message {
    return Intl.message(
      'Welcome to the Smart Fire Alarm System. Please login or sign up.',
      name: 'welcome_message',
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
