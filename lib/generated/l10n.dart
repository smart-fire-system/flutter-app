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

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
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

  /// `A confirmation email has been sent. Please check your inbox.`
  String get confirmEmailSent {
    return Intl.message(
      'A confirmation email has been sent. Please check your inbox.',
      name: 'confirmEmailSent',
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

  /// `Search by name or code ...`
  String get searchByNameCode {
    return Intl.message(
      'Search by name or code ...',
      name: 'searchByNameCode',
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

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get myProfile {
    return Intl.message(
      'Profile',
      name: 'myProfile',
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

  /// `Branches`
  String get branches {
    return Intl.message(
      'Branches',
      name: 'branches',
      desc: '',
      args: [],
    );
  }

  /// `Companies`
  String get companies {
    return Intl.message(
      'Companies',
      name: 'companies',
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

  /// `Seleect Users`
  String get selectUsers {
    return Intl.message(
      'Seleect Users',
      name: 'selectUsers',
      desc: '',
      args: [],
    );
  }

  /// `All Users`
  String get allUsers {
    return Intl.message(
      'All Users',
      name: 'allUsers',
      desc: '',
      args: [],
    );
  }

  /// `No users selected`
  String get noUsersSelected {
    return Intl.message(
      'No users selected',
      name: 'noUsersSelected',
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

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Master Admins`
  String get masterAdmins {
    return Intl.message(
      'Master Admins',
      name: 'masterAdmins',
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

  /// `Company Managers`
  String get companyManagers {
    return Intl.message(
      'Company Managers',
      name: 'companyManagers',
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

  /// `Clients`
  String get clients {
    return Intl.message(
      'Clients',
      name: 'clients',
      desc: '',
      args: [],
    );
  }

  /// `No Role Users`
  String get noRoleUsers {
    return Intl.message(
      'No Role Users',
      name: 'noRoleUsers',
      desc: '',
      args: [],
    );
  }

  /// `Master Admin`
  String get masterAdmin {
    return Intl.message(
      'Master Admin',
      name: 'masterAdmin',
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

  /// `Company Manager`
  String get companyManager {
    return Intl.message(
      'Company Manager',
      name: 'companyManager',
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

  /// `Choose access role`
  String get chooseRole {
    return Intl.message(
      'Choose access role',
      name: 'chooseRole',
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

  /// `Add or remove branches`
  String get branchesDescription {
    return Intl.message(
      'Add or remove branches',
      name: 'branchesDescription',
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

  /// `Companies and Branches`
  String get companiesAndBranches {
    return Intl.message(
      'Companies and Branches',
      name: 'companiesAndBranches',
      desc: '',
      args: [],
    );
  }

  /// `Manage companies and their branches. Add or remove companies and branches, and view detailed information about them.`
  String get companiesAndBranchesDescription {
    return Intl.message(
      'Manage companies and their branches. Add or remove companies and branches, and view detailed information about them.',
      name: 'companiesAndBranchesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add New Master Admin`
  String get addNewMasterAdmin {
    return Intl.message(
      'Add New Master Admin',
      name: 'addNewMasterAdmin',
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

  /// `Add New Company Manager`
  String get addNewCompanyManager {
    return Intl.message(
      'Add New Company Manager',
      name: 'addNewCompanyManager',
      desc: '',
      args: [],
    );
  }

  /// `Add New Branch Manager`
  String get addNewBranchManager {
    return Intl.message(
      'Add New Branch Manager',
      name: 'addNewBranchManager',
      desc: '',
      args: [],
    );
  }

  /// `Add New Employee`
  String get addNewEmployee {
    return Intl.message(
      'Add New Employee',
      name: 'addNewEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Add New Client`
  String get addNewClient {
    return Intl.message(
      'Add New Client',
      name: 'addNewClient',
      desc: '',
      args: [],
    );
  }

  /// `No users to view.`
  String get noUsersToView {
    return Intl.message(
      'No users to view.',
      name: 'noUsersToView',
      desc: '',
      args: [],
    );
  }

  /// `There are no companies to add company managers to. Please add a company first.`
  String get noCompaneiesToAddCompanyManager {
    return Intl.message(
      'There are no companies to add company managers to. Please add a company first.',
      name: 'noCompaneiesToAddCompanyManager',
      desc: '',
      args: [],
    );
  }

  /// `There are no branches to add branch managers to. Please add a branch first.`
  String get noBranchesToAddBranchManager {
    return Intl.message(
      'There are no branches to add branch managers to. Please add a branch first.',
      name: 'noBranchesToAddBranchManager',
      desc: '',
      args: [],
    );
  }

  /// `There are no branches to add employees to. Please add a branch first.`
  String get noBranchesToAddEmployee {
    return Intl.message(
      'There are no branches to add employees to. Please add a branch first.',
      name: 'noBranchesToAddEmployee',
      desc: '',
      args: [],
    );
  }

  /// `There are no branches to add clients to. Please add a branch first.`
  String get noBranchesToAddClient {
    return Intl.message(
      'There are no branches to add clients to. Please add a branch first.',
      name: 'noBranchesToAddClient',
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

  /// `Pleae wait while loading data ...`
  String get wait_while_loading {
    return Intl.message(
      'Pleae wait while loading data ...',
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

  /// `Select companies to view`
  String get selectCompanies {
    return Intl.message(
      'Select companies to view',
      name: 'selectCompanies',
      desc: '',
      args: [],
    );
  }

  /// `All companies`
  String get allCompanies {
    return Intl.message(
      'All companies',
      name: 'allCompanies',
      desc: '',
      args: [],
    );
  }

  /// `No companies selected`
  String get noCompaniesSelected {
    return Intl.message(
      'No companies selected',
      name: 'noCompaniesSelected',
      desc: '',
      args: [],
    );
  }

  /// `No branches to view`
  String get noBranchesToView {
    return Intl.message(
      'No branches to view',
      name: 'noBranchesToView',
      desc: '',
      args: [],
    );
  }

  /// `No companies to view`
  String get noCompaniesToView {
    return Intl.message(
      'No companies to view',
      name: 'noCompaniesToView',
      desc: '',
      args: [],
    );
  }

  /// `There are no companies to add branches to. Please add a company first`
  String get noCompaniesToAddBranch {
    return Intl.message(
      'There are no companies to add branches to. Please add a company first',
      name: 'noCompaniesToAddBranch',
      desc: '',
      args: [],
    );
  }

  /// `Branch Information`
  String get branchInformation {
    return Intl.message(
      'Branch Information',
      name: 'branchInformation',
      desc: '',
      args: [],
    );
  }

  /// `Company Information`
  String get companyInformation {
    return Intl.message(
      'Company Information',
      name: 'companyInformation',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contactInformation {
    return Intl.message(
      'Contact Information',
      name: 'contactInformation',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get code {
    return Intl.message(
      'Code',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Created At`
  String get createdAt {
    return Intl.message(
      'Created At',
      name: 'createdAt',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Add New Branch`
  String get addBranch {
    return Intl.message(
      'Add New Branch',
      name: 'addBranch',
      desc: '',
      args: [],
    );
  }

  /// `The branch details have been updated successfully.`
  String get branchModified {
    return Intl.message(
      'The branch details have been updated successfully.',
      name: 'branchModified',
      desc: '',
      args: [],
    );
  }

  /// `The branch has been added successfully.`
  String get branchAdded {
    return Intl.message(
      'The branch has been added successfully.',
      name: 'branchAdded',
      desc: '',
      args: [],
    );
  }

  /// `The branch has been deleted successfully.`
  String get branchDeleted {
    return Intl.message(
      'The branch has been deleted successfully.',
      name: 'branchDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Branch Name`
  String get branchName {
    return Intl.message(
      'Branch Name',
      name: 'branchName',
      desc: '',
      args: [],
    );
  }

  /// `Edit Branch`
  String get editBranch {
    return Intl.message(
      'Edit Branch',
      name: 'editBranch',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get company {
    return Intl.message(
      'Company',
      name: 'company',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get branch {
    return Intl.message(
      'Branch',
      name: 'branch',
      desc: '',
      args: [],
    );
  }

  /// `Change Company`
  String get changeCompany {
    return Intl.message(
      'Change Company',
      name: 'changeCompany',
      desc: '',
      args: [],
    );
  }

  /// `Delete Branch`
  String get deleteBranch {
    return Intl.message(
      'Delete Branch',
      name: 'deleteBranch',
      desc: '',
      args: [],
    );
  }

  /// `Please double-check the updated branch details before saving. Are you sure you want to proceed?`
  String get branchModifyWarning {
    return Intl.message(
      'Please double-check the updated branch details before saving. Are you sure you want to proceed?',
      name: 'branchModifyWarning',
      desc: '',
      args: [],
    );
  }

  /// `Deleting this branch is irreversible. Are you sure you want to proceed?`
  String get branchDeleteWarning {
    return Intl.message(
      'Deleting this branch is irreversible. Are you sure you want to proceed?',
      name: 'branchDeleteWarning',
      desc: '',
      args: [],
    );
  }

  /// `Yes, delete branch`
  String get yesDeleteBranch {
    return Intl.message(
      'Yes, delete branch',
      name: 'yesDeleteBranch',
      desc: '',
      args: [],
    );
  }

  /// `Yes, save changes`
  String get yesSaveChanges {
    return Intl.message(
      'Yes, save changes',
      name: 'yesSaveChanges',
      desc: '',
      args: [],
    );
  }

  /// `No, cancel`
  String get noCancel {
    return Intl.message(
      'No, cancel',
      name: 'noCancel',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while deleting branch`
  String get waitDeltingBranch {
    return Intl.message(
      'Please wait while deleting branch',
      name: 'waitDeltingBranch',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while saving branch information`
  String get waitSavingBranch {
    return Intl.message(
      'Please wait while saving branch information',
      name: 'waitSavingBranch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the branch name`
  String get enterBranchName {
    return Intl.message(
      'Please enter the branch name',
      name: 'enterBranchName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the branch address`
  String get enterBranchAddress {
    return Intl.message(
      'Please enter the branch address',
      name: 'enterBranchAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the branch phone number`
  String get enterBranchPhone {
    return Intl.message(
      'Please enter the branch phone number',
      name: 'enterBranchPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the branch email address`
  String get enterBranchEmail {
    return Intl.message(
      'Please enter the branch email address',
      name: 'enterBranchEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a company for this branch`
  String get enterBranchCompany {
    return Intl.message(
      'Please choose a company for this branch',
      name: 'enterBranchCompany',
      desc: '',
      args: [],
    );
  }

  /// `Add New Company`
  String get addCompany {
    return Intl.message(
      'Add New Company',
      name: 'addCompany',
      desc: '',
      args: [],
    );
  }

  /// `The company details have been updated successfully.`
  String get companyModified {
    return Intl.message(
      'The company details have been updated successfully.',
      name: 'companyModified',
      desc: '',
      args: [],
    );
  }

  /// `The company has been added successfully.`
  String get companyAdded {
    return Intl.message(
      'The company has been added successfully.',
      name: 'companyAdded',
      desc: '',
      args: [],
    );
  }

  /// `The company has been deleted successfully.`
  String get companyDeleted {
    return Intl.message(
      'The company has been deleted successfully.',
      name: 'companyDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get companyName {
    return Intl.message(
      'Company Name',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `Edit Company`
  String get editCompany {
    return Intl.message(
      'Edit Company',
      name: 'editCompany',
      desc: '',
      args: [],
    );
  }

  /// `Delete Company`
  String get deleteCompany {
    return Intl.message(
      'Delete Company',
      name: 'deleteCompany',
      desc: '',
      args: [],
    );
  }

  /// `Please double-check the updated company details before saving. Are you sure you want to proceed?`
  String get companyModifyWarning {
    return Intl.message(
      'Please double-check the updated company details before saving. Are you sure you want to proceed?',
      name: 'companyModifyWarning',
      desc: '',
      args: [],
    );
  }

  /// `Deleting this company is irreversible. Are you sure you want to proceed?`
  String get companyDeleteWarning {
    return Intl.message(
      'Deleting this company is irreversible. Are you sure you want to proceed?',
      name: 'companyDeleteWarning',
      desc: '',
      args: [],
    );
  }

  /// `Yes, delete company`
  String get yesDeleteCompany {
    return Intl.message(
      'Yes, delete company',
      name: 'yesDeleteCompany',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while deleting company`
  String get waitDeltingCompany {
    return Intl.message(
      'Please wait while deleting company',
      name: 'waitDeltingCompany',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while saving company information`
  String get waitSavingCompany {
    return Intl.message(
      'Please wait while saving company information',
      name: 'waitSavingCompany',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the company name`
  String get enterCompanyName {
    return Intl.message(
      'Please enter the company name',
      name: 'enterCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the company address`
  String get enterCompanyAddress {
    return Intl.message(
      'Please enter the company address',
      name: 'enterCompanyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the company phone number`
  String get enterCompanyPhone {
    return Intl.message(
      'Please enter the company phone number',
      name: 'enterCompanyPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the company email address`
  String get enterCompanyEmail {
    return Intl.message(
      'Please enter the company email address',
      name: 'enterCompanyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please add a logo for the company`
  String get enterCompanyLogo {
    return Intl.message(
      'Please add a logo for the company',
      name: 'enterCompanyLogo',
      desc: '',
      args: [],
    );
  }

  /// `Tab to add company logo`
  String get tabToAddLogo {
    return Intl.message(
      'Tab to add company logo',
      name: 'tabToAddLogo',
      desc: '',
      args: [],
    );
  }

  /// `Logo`
  String get logo {
    return Intl.message(
      'Logo',
      name: 'logo',
      desc: '',
      args: [],
    );
  }

  /// `Company Logo`
  String get companyLogo {
    return Intl.message(
      'Company Logo',
      name: 'companyLogo',
      desc: '',
      args: [],
    );
  }

  /// `An error occured while choosing the image`
  String get errorPickingImage {
    return Intl.message(
      'An error occured while choosing the image',
      name: 'errorPickingImage',
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

  /// `Tap to select a user`
  String get tapToSelectUser {
    return Intl.message(
      'Tap to select a user',
      name: 'tapToSelectUser',
      desc: '',
      args: [],
    );
  }

  /// `Admin Permissions`
  String get adminPermissions {
    return Intl.message(
      'Admin Permissions',
      name: 'adminPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Can update admins`
  String get canUpdateAdmins {
    return Intl.message(
      'Can update admins',
      name: 'canUpdateAdmins',
      desc: '',
      args: [],
    );
  }

  /// `Can update company managers`
  String get canUpdateCompanyManagers {
    return Intl.message(
      'Can update company managers',
      name: 'canUpdateCompanyManagers',
      desc: '',
      args: [],
    );
  }

  /// `Can update branch managers`
  String get canUpdateBranchManagers {
    return Intl.message(
      'Can update branch managers',
      name: 'canUpdateBranchManagers',
      desc: '',
      args: [],
    );
  }

  /// `Can update employees`
  String get canUpdateEmployees {
    return Intl.message(
      'Can update employees',
      name: 'canUpdateEmployees',
      desc: '',
      args: [],
    );
  }

  /// `Can update clients`
  String get canUpdateClients {
    return Intl.message(
      'Can update clients',
      name: 'canUpdateClients',
      desc: '',
      args: [],
    );
  }

  /// `Can add companies`
  String get canAddCompanies {
    return Intl.message(
      'Can add companies',
      name: 'canAddCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Can edit companies`
  String get canEditCompanies {
    return Intl.message(
      'Can edit companies',
      name: 'canEditCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Can delete companies`
  String get canDeleteCompanies {
    return Intl.message(
      'Can delete companies',
      name: 'canDeleteCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Can add branches`
  String get canAddBranches {
    return Intl.message(
      'Can add branches',
      name: 'canAddBranches',
      desc: '',
      args: [],
    );
  }

  /// `Can edit branches`
  String get canEditBranches {
    return Intl.message(
      'Can edit branches',
      name: 'canEditBranches',
      desc: '',
      args: [],
    );
  }

  /// `Can delete branches`
  String get canDeleteBranches {
    return Intl.message(
      'Can delete branches',
      name: 'canDeleteBranches',
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

  /// `You must sign first to activate the contract. Tap to sign.`
  String get contract_wait_employee_sign_subtitle {
    return Intl.message(
      'You must sign first to activate the contract. Tap to sign.',
      name: 'contract_wait_employee_sign_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for client signature`
  String get contract_wait_other_client_sign_title {
    return Intl.message(
      'Waiting for client signature',
      name: 'contract_wait_other_client_sign_title',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for the client signature to activate the contract.`
  String get contract_wait_other_client_sign_subtitle {
    return Intl.message(
      'Waiting for the client signature to activate the contract.',
      name: 'contract_wait_other_client_sign_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Contract Active`
  String get contract_active_title {
    return Intl.message(
      'Contract Active',
      name: 'contract_active_title',
      desc: '',
      args: [],
    );
  }

  /// `Active until {date}`
  String contract_active_until(Object date) {
    return Intl.message(
      'Active until $date',
      name: 'contract_active_until',
      desc: '',
      args: [date],
    );
  }

  /// `Contract Expired`
  String get contract_expired_title {
    return Intl.message(
      'Contract Expired',
      name: 'contract_expired_title',
      desc: '',
      args: [],
    );
  }

  /// `Expired on {date}`
  String contract_expired_since(Object date) {
    return Intl.message(
      'Expired on $date',
      name: 'contract_expired_since',
      desc: '',
      args: [date],
    );
  }

  /// `Signing is not enabled yet`
  String get snackbar_signing_not_enabled {
    return Intl.message(
      'Signing is not enabled yet',
      name: 'snackbar_signing_not_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Client notification is not enabled yet`
  String get snackbar_client_notification_not_enabled {
    return Intl.message(
      'Client notification is not enabled yet',
      name: 'snackbar_client_notification_not_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Employee Signature`
  String get signature_employee_title {
    return Intl.message(
      'Employee Signature',
      name: 'signature_employee_title',
      desc: '',
      args: [],
    );
  }

  /// `Client Signature`
  String get signature_client_title {
    return Intl.message(
      'Client Signature',
      name: 'signature_client_title',
      desc: '',
      args: [],
    );
  }

  /// `Confirm {title}`
  String signature_confirm_dialog_title(Object title) {
    return Intl.message(
      'Confirm $title',
      name: 'signature_confirm_dialog_title',
      desc: '',
      args: [title],
    );
  }

  /// `By confirming, your signature will be recorded on this contract. This action cannot be undone.`
  String get signature_confirm_dialog_body {
    return Intl.message(
      'By confirming, your signature will be recorded on this contract. This action cannot be undone.',
      name: 'signature_confirm_dialog_body',
      desc: '',
      args: [],
    );
  }

  /// `Slide to confirm`
  String get slide_to_confirm {
    return Intl.message(
      'Slide to confirm',
      name: 'slide_to_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get linear_stage_draft {
    return Intl.message(
      'Draft',
      name: 'linear_stage_draft',
      desc: '',
      args: [],
    );
  }

  /// `Employee Signed`
  String get linear_stage_employee_signed {
    return Intl.message(
      'Employee Signed',
      name: 'linear_stage_employee_signed',
      desc: '',
      args: [],
    );
  }

  /// `Client Signed`
  String get linear_stage_client_signed {
    return Intl.message(
      'Client Signed',
      name: 'linear_stage_client_signed',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get linear_stage_active {
    return Intl.message(
      'Active',
      name: 'linear_stage_active',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get linear_stage_expired {
    return Intl.message(
      'Expired',
      name: 'linear_stage_expired',
      desc: '',
      args: [],
    );
  }

  /// `Contract No: {number}`
  String contract_number_prefix(Object number) {
    return Intl.message(
      'Contract No: $number',
      name: 'contract_number_prefix',
      desc: '',
      args: [number],
    );
  }

  /// `Contract`
  String get contract_label {
    return Intl.message(
      'Contract',
      name: 'contract_label',
      desc: '',
      args: [],
    );
  }

  /// `Active from `
  String get period_from {
    return Intl.message(
      'Active from ',
      name: 'period_from',
      desc: '',
      args: [],
    );
  }

  /// ` to `
  String get period_to {
    return Intl.message(
      ' to ',
      name: 'period_to',
      desc: '',
      args: [],
    );
  }

  /// `Employee: `
  String get employee_label {
    return Intl.message(
      'Employee: ',
      name: 'employee_label',
      desc: '',
      args: [],
    );
  }

  /// `Client: `
  String get client_label {
    return Intl.message(
      'Client: ',
      name: 'client_label',
      desc: '',
      args: [],
    );
  }

  /// `Branch: `
  String get branch_label {
    return Intl.message(
      'Branch: ',
      name: 'branch_label',
      desc: '',
      args: [],
    );
  }

  /// `Employee signature required`
  String get sign_employee_required_title {
    return Intl.message(
      'Employee signature required',
      name: 'sign_employee_required_title',
      desc: '',
      args: [],
    );
  }

  /// `You must sign first so the client can sign. Tap to sign.`
  String get sign_employee_required_subtitle {
    return Intl.message(
      'You must sign first so the client can sign. Tap to sign.',
      name: 'sign_employee_required_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for employee signature`
  String get waiting_employee_signature_title {
    return Intl.message(
      'Waiting for employee signature',
      name: 'waiting_employee_signature_title',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for the employee signature so the client can sign.`
  String get waiting_employee_signature_subtitle {
    return Intl.message(
      'Waiting for the employee signature so the client can sign.',
      name: 'waiting_employee_signature_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Client signature required`
  String get sign_client_required_title {
    return Intl.message(
      'Client signature required',
      name: 'sign_client_required_title',
      desc: '',
      args: [],
    );
  }

  /// `View Contract`
  String get view_contract {
    return Intl.message(
      'View Contract',
      name: 'view_contract',
      desc: '',
      args: [],
    );
  }

  /// `View contract details and export to PDF`
  String get view_contract_subtitle {
    return Intl.message(
      'View contract details and export to PDF',
      name: 'view_contract_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Add new visit report`
  String get new_visit_report {
    return Intl.message(
      'Add new visit report',
      name: 'new_visit_report',
      desc: '',
      args: [],
    );
  }

  /// `Add new visit report`
  String get new_visit_report_subtitle {
    return Intl.message(
      'Add new visit report',
      name: 'new_visit_report_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Visit Reports`
  String get visit_reports {
    return Intl.message(
      'Visit Reports',
      name: 'visit_reports',
      desc: '',
      args: [],
    );
  }

  /// `View visit details and export to PDF`
  String get visit_reports_subtitle {
    return Intl.message(
      'View visit details and export to PDF',
      name: 'visit_reports_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Request emergency visit`
  String get emergency_visit_request {
    return Intl.message(
      'Request emergency visit',
      name: 'emergency_visit_request',
      desc: '',
      args: [],
    );
  }

  /// `Request emergency visit`
  String get emergency_visit_request_subtitle {
    return Intl.message(
      'Request emergency visit',
      name: 'emergency_visit_request_subtitle',
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
