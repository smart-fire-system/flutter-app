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

  /// `Fire Alarm System`
  String get app_name {
    return Intl.message(
      'Fire Alarm System',
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

  /// `Search by name, email or phone number ...`
  String get searchBy {
    return Intl.message(
      'Search by name, email or phone number ...',
      name: 'searchBy',
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

  /// `You are not logged in. To access this feature, please log in with your account.`
  String get not_authenticated {
    return Intl.message(
      'You are not logged in. To access this feature, please log in with your account.',
      name: 'not_authenticated',
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

  /// `Welcome to the Fire Alarm System. Please login or sign up.`
  String get welcome_message {
    return Intl.message(
      'Welcome to the Fire Alarm System. Please login or sign up.',
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

  /// `Continue with Google`
  String get continue_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_with_google',
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

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Edit Inforamation`
  String get edit_information {
    return Intl.message(
      'Edit Inforamation',
      name: 'edit_information',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get save_changes {
    return Intl.message(
      'Save Changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Profile info updated successfully`
  String get info_updated {
    return Intl.message(
      'Profile info updated successfully',
      name: 'info_updated',
      desc: '',
      args: [],
    );
  }

  /// `To continue using the application, please complete the following steps:`
  String get stepsToComplete {
    return Intl.message(
      'To continue using the application, please complete the following steps:',
      name: 'stepsToComplete',
      desc: '',
      args: [],
    );
  }

  /// `Email Verification`
  String get emailVerificationTitle {
    return Intl.message(
      'Email Verification',
      name: 'emailVerificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your email has been successfully verified.`
  String get emailVerified {
    return Intl.message(
      'Your email has been successfully verified.',
      name: 'emailVerified',
      desc: '',
      args: [],
    );
  }

  /// `Your email is not verified. Click here to resend the verification email.`
  String get emailNotVerified {
    return Intl.message(
      'Your email is not verified. Click here to resend the verification email.',
      name: 'emailNotVerified',
      desc: '',
      args: [],
    );
  }

  /// `Add Phone Number`
  String get phoneNumberTitle {
    return Intl.message(
      'Add Phone Number',
      name: 'phoneNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your phone number has been added.`
  String get phoneNumberAdded {
    return Intl.message(
      'Your phone number has been added.',
      name: 'phoneNumberAdded',
      desc: '',
      args: [],
    );
  }

  /// `You have not added a phone number. Click here to add your phone number.`
  String get phoneNumberNotAdded {
    return Intl.message(
      'You have not added a phone number. Click here to add your phone number.',
      name: 'phoneNumberNotAdded',
      desc: '',
      args: [],
    );
  }

  /// `Access Role`
  String get accessRoleTitle {
    return Intl.message(
      'Access Role',
      name: 'accessRoleTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have been assigned an access role.`
  String get roleAssigned {
    return Intl.message(
      'You have been assigned an access role.',
      name: 'roleAssigned',
      desc: '',
      args: [],
    );
  }

  /// `You don't have an access role yet. Please wait for an administrator to grant you access.`
  String get roleNotAssigned {
    return Intl.message(
      'You don\'t have an access role yet. Please wait for an administrator to grant you access.',
      name: 'roleNotAssigned',
      desc: '',
      args: [],
    );
  }

  /// `The custom authentication token you provided is invalid. Please check and try again.`
  String get invalid_custom_token {
    return Intl.message(
      'The custom authentication token you provided is invalid. Please check and try again.',
      name: 'invalid_custom_token',
      desc: '',
      args: [],
    );
  }

  /// `The custom token provided does not match the expected format. Ensure it is correct.`
  String get custom_token_mismatch {
    return Intl.message(
      'The custom token provided does not match the expected format. Ensure it is correct.',
      name: 'custom_token_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `The email address entered is not valid. Please provide a valid email address.`
  String get invalid_email {
    return Intl.message(
      'The email address entered is not valid. Please provide a valid email address.',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `The credentials you provided are not recognized. Please check your login details.`
  String get invalid_credential {
    return Intl.message(
      'The credentials you provided are not recognized. Please check your login details.',
      name: 'invalid_credential',
      desc: '',
      args: [],
    );
  }

  /// `This account has been disabled by the administrator. Contact support for assistance.`
  String get user_disabled {
    return Intl.message(
      'This account has been disabled by the administrator. Contact support for assistance.',
      name: 'user_disabled',
      desc: '',
      args: [],
    );
  }

  /// `An account already exists with this email address. Please login or use a different email.`
  String get email_already_in_use {
    return Intl.message(
      'An account already exists with this email address. Please login or use a different email.',
      name: 'email_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `The password you entered is incorrect. Please try again.`
  String get wrong_password {
    return Intl.message(
      'The password you entered is incorrect. Please try again.',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests. Please wait for a while before trying again.`
  String get too_many_requests {
    return Intl.message(
      'Too many requests. Please wait for a while before trying again.',
      name: 'too_many_requests',
      desc: '',
      args: [],
    );
  }

  /// `An account with this email exists but with different credentials. Try logging in with a different method.`
  String get account_exists_with_different_credentials {
    return Intl.message(
      'An account with this email exists but with different credentials. Try logging in with a different method.',
      name: 'account_exists_with_different_credentials',
      desc: '',
      args: [],
    );
  }

  /// `For security purposes, please log in again to continue.`
  String get requires_recent_login {
    return Intl.message(
      'For security purposes, please log in again to continue.',
      name: 'requires_recent_login',
      desc: '',
      args: [],
    );
  }

  /// `This account is already linked to another authentication provider.`
  String get provider_already_linked {
    return Intl.message(
      'This account is already linked to another authentication provider.',
      name: 'provider_already_linked',
      desc: '',
      args: [],
    );
  }

  /// `The provider you are trying to use is not available for this account.`
  String get no_such_provider {
    return Intl.message(
      'The provider you are trying to use is not available for this account.',
      name: 'no_such_provider',
      desc: '',
      args: [],
    );
  }

  /// `The user token is invalid. Please log in again.`
  String get invalid_user_token {
    return Intl.message(
      'The user token is invalid. Please log in again.',
      name: 'invalid_user_token',
      desc: '',
      args: [],
    );
  }

  /// `The session has expired. Please log in again.`
  String get user_token_expired {
    return Intl.message(
      'The session has expired. Please log in again.',
      name: 'user_token_expired',
      desc: '',
      args: [],
    );
  }

  /// `No user was found with this information. Please check your details.`
  String get user_not_found {
    return Intl.message(
      'No user was found with this information. Please check your details.',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `The API key used is invalid. Contact support if the issue persists.`
  String get invalid_api_key {
    return Intl.message(
      'The API key used is invalid. Contact support if the issue persists.',
      name: 'invalid_api_key',
      desc: '',
      args: [],
    );
  }

  /// `This credential is already in use with another account. Try a different login method.`
  String get credential_already_in_use {
    return Intl.message(
      'This credential is already in use with another account. Try a different login method.',
      name: 'credential_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `This operation is not allowed. Contact the administrator for more information.`
  String get operation_not_allowed {
    return Intl.message(
      'This operation is not allowed. Contact the administrator for more information.',
      name: 'operation_not_allowed',
      desc: '',
      args: [],
    );
  }

  /// `The password entered is too weak. Use a stronger password with more characters.`
  String get weak_password {
    return Intl.message(
      'The password entered is too weak. Use a stronger password with more characters.',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `This app is not authorized to access the Firebase project. Contact the administrator.`
  String get app_not_authorized {
    return Intl.message(
      'This app is not authorized to access the Firebase project. Contact the administrator.',
      name: 'app_not_authorized',
      desc: '',
      args: [],
    );
  }

  /// `This action code has expired. Request a new one to proceed.`
  String get expired_action_code {
    return Intl.message(
      'This action code has expired. Request a new one to proceed.',
      name: 'expired_action_code',
      desc: '',
      args: [],
    );
  }

  /// `The action code provided is invalid or has already been used.`
  String get invalid_action_code {
    return Intl.message(
      'The action code provided is invalid or has already been used.',
      name: 'invalid_action_code',
      desc: '',
      args: [],
    );
  }

  /// `The message payload is invalid. Please contact support.`
  String get invalid_message_payload {
    return Intl.message(
      'The message payload is invalid. Please contact support.',
      name: 'invalid_message_payload',
      desc: '',
      args: [],
    );
  }

  /// `The sender is not authorized. Please ensure you are using a valid email.`
  String get invalid_sender {
    return Intl.message(
      'The sender is not authorized. Please ensure you are using a valid email.',
      name: 'invalid_sender',
      desc: '',
      args: [],
    );
  }

  /// `The recipient email address is invalid. Please check and try again.`
  String get invalid_recipient_email {
    return Intl.message(
      'The recipient email address is invalid. Please check and try again.',
      name: 'invalid_recipient_email',
      desc: '',
      args: [],
    );
  }

  /// `The domain you are trying to use is not authorized. Contact support for further details.`
  String get unauthorized_domain {
    return Intl.message(
      'The domain you are trying to use is not authorized. Contact support for further details.',
      name: 'unauthorized_domain',
      desc: '',
      args: [],
    );
  }

  /// `The continue URL provided is invalid.`
  String get invalid_continue_uri {
    return Intl.message(
      'The continue URL provided is invalid.',
      name: 'invalid_continue_uri',
      desc: '',
      args: [],
    );
  }

  /// `A continue URL is required but missing. Please provide one.`
  String get missing_continue_uri {
    return Intl.message(
      'A continue URL is required but missing. Please provide one.',
      name: 'missing_continue_uri',
      desc: '',
      args: [],
    );
  }

  /// `The email field is required. Please provide an email address.`
  String get missing_email {
    return Intl.message(
      'The email field is required. Please provide an email address.',
      name: 'missing_email',
      desc: '',
      args: [],
    );
  }

  /// `The phone number field is required. Please provide a phone number.`
  String get missing_phone_number {
    return Intl.message(
      'The phone number field is required. Please provide a phone number.',
      name: 'missing_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `The phone number entered is invalid. Please provide a valid phone number.`
  String get invalid_phone_number {
    return Intl.message(
      'The phone number entered is invalid. Please provide a valid phone number.',
      name: 'invalid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `The verification code is missing. Please enter the code sent to you.`
  String get missing_verification_code {
    return Intl.message(
      'The verification code is missing. Please enter the code sent to you.',
      name: 'missing_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `The verification code entered is invalid. Please try again.`
  String get invalid_verification_code {
    return Intl.message(
      'The verification code entered is invalid. Please try again.',
      name: 'invalid_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `The verification ID is missing. Please try the process again.`
  String get missing_verification_id {
    return Intl.message(
      'The verification ID is missing. Please try the process again.',
      name: 'missing_verification_id',
      desc: '',
      args: [],
    );
  }

  /// `The verification ID entered is invalid. Please try again.`
  String get invalid_verification_id {
    return Intl.message(
      'The verification ID entered is invalid. Please try again.',
      name: 'invalid_verification_id',
      desc: '',
      args: [],
    );
  }

  /// `The session has expired. Please log in again.`
  String get session_expired {
    return Intl.message(
      'The session has expired. Please log in again.',
      name: 'session_expired',
      desc: '',
      args: [],
    );
  }

  /// `The quota for this operation has been exceeded. Try again later.`
  String get quota_exceeded {
    return Intl.message(
      'The quota for this operation has been exceeded. Try again later.',
      name: 'quota_exceeded',
      desc: '',
      args: [],
    );
  }

  /// `The app credential is missing. Please try again.`
  String get missing_app_credential {
    return Intl.message(
      'The app credential is missing. Please try again.',
      name: 'missing_app_credential',
      desc: '',
      args: [],
    );
  }

  /// `The app credential entered is invalid.`
  String get invalid_app_credential {
    return Intl.message(
      'The app credential entered is invalid.',
      name: 'invalid_app_credential',
      desc: '',
      args: [],
    );
  }

  /// `The client identifier is missing.`
  String get missing_client_identifier {
    return Intl.message(
      'The client identifier is missing.',
      name: 'missing_client_identifier',
      desc: '',
      args: [],
    );
  }

  /// `The tenant ID does not match the expected value.`
  String get tenant_id_mismatch {
    return Intl.message(
      'The tenant ID does not match the expected value.',
      name: 'tenant_id_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `This operation is not supported for this tenant.`
  String get unsupported_tenant_operation {
    return Intl.message(
      'This operation is not supported for this tenant.',
      name: 'unsupported_tenant_operation',
      desc: '',
      args: [],
    );
  }

  /// `The logged-in user does not match the expected user.`
  String get user_mismatch {
    return Intl.message(
      'The logged-in user does not match the expected user.',
      name: 'user_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `A network error occurred. Please check your connection and try again.`
  String get network_request_failed {
    return Intl.message(
      'A network error occurred. Please check your connection and try again.',
      name: 'network_request_failed',
      desc: '',
      args: [],
    );
  }

  /// `No user is signed in. Please log in to continue.`
  String get no_signed_in_user {
    return Intl.message(
      'No user is signed in. Please log in to continue.',
      name: 'no_signed_in_user',
      desc: '',
      args: [],
    );
  }

  /// `The operation was cancelled. Please try again.`
  String get cancelled {
    return Intl.message(
      'The operation was cancelled. Please try again.',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred. Please try again later.`
  String get unknown_error {
    return Intl.message(
      'An unknown error occurred. Please try again later.',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `An invalid argument was provided. Please check your input.`
  String get invalid_argument {
    return Intl.message(
      'An invalid argument was provided. Please check your input.',
      name: 'invalid_argument',
      desc: '',
      args: [],
    );
  }

  /// `The operation took too long to complete. Please try again later.`
  String get deadline_exceeded {
    return Intl.message(
      'The operation took too long to complete. Please try again later.',
      name: 'deadline_exceeded',
      desc: '',
      args: [],
    );
  }

  /// `The requested resource was not found.`
  String get not_found {
    return Intl.message(
      'The requested resource was not found.',
      name: 'not_found',
      desc: '',
      args: [],
    );
  }

  /// `The resource already exists.`
  String get already_exists {
    return Intl.message(
      'The resource already exists.',
      name: 'already_exists',
      desc: '',
      args: [],
    );
  }

  /// `You do not have permission to perform this action.`
  String get permission_denied {
    return Intl.message(
      'You do not have permission to perform this action.',
      name: 'permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Resource limit exceeded. Please try again later.`
  String get resource_exhausted {
    return Intl.message(
      'Resource limit exceeded. Please try again later.',
      name: 'resource_exhausted',
      desc: '',
      args: [],
    );
  }

  /// `The operation cannot be performed due to failed precondition.`
  String get failed_precondition {
    return Intl.message(
      'The operation cannot be performed due to failed precondition.',
      name: 'failed_precondition',
      desc: '',
      args: [],
    );
  }

  /// `The operation was aborted due to a conflict.`
  String get aborted {
    return Intl.message(
      'The operation was aborted due to a conflict.',
      name: 'aborted',
      desc: '',
      args: [],
    );
  }

  /// `The provided value is out of the acceptable range.`
  String get out_of_range {
    return Intl.message(
      'The provided value is out of the acceptable range.',
      name: 'out_of_range',
      desc: '',
      args: [],
    );
  }

  /// `This operation is not implemented or supported.`
  String get unimplemented {
    return Intl.message(
      'This operation is not implemented or supported.',
      name: 'unimplemented',
      desc: '',
      args: [],
    );
  }

  /// `An internal error occurred. Please try again later.`
  String get internal {
    return Intl.message(
      'An internal error occurred. Please try again later.',
      name: 'internal',
      desc: '',
      args: [],
    );
  }

  /// `The service is currently unavailable. Please check your connection or try again later.`
  String get unavailable {
    return Intl.message(
      'The service is currently unavailable. Please check your connection or try again later.',
      name: 'unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Data loss occurred. Please try again later.`
  String get data_loss {
    return Intl.message(
      'Data loss occurred. Please try again later.',
      name: 'data_loss',
      desc: '',
      args: [],
    );
  }

  /// `You need to sign in to perform this action.`
  String get unauthenticated {
    return Intl.message(
      'You need to sign in to perform this action.',
      name: 'unauthenticated',
      desc: '',
      args: [],
    );
  }

  /// `The sign-in attempt has failed. Please try again later or contact support if the issue persists.`
  String get sign_in_failed {
    return Intl.message(
      'The sign-in attempt has failed. Please try again later or contact support if the issue persists.',
      name: 'sign_in_failed',
      desc: '',
      args: [],
    );
  }

  /// `A network error occurred during sign-in. Please check your internet connection and try again.`
  String get network_error {
    return Intl.message(
      'A network error occurred during sign-in. Please check your internet connection and try again.',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `The sign-in process was cancelled. Please try again if you want to continue.`
  String get sign_in_cancelled {
    return Intl.message(
      'The sign-in process was cancelled. Please try again if you want to continue.',
      name: 'sign_in_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `You need to sign in to proceed. Please sign in and try again.`
  String get sign_in_required {
    return Intl.message(
      'You need to sign in to proceed. Please sign in and try again.',
      name: 'sign_in_required',
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
