import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Fire Alarm System'**
  String get app_name;

  /// No description provided for @account_not_verified_title.
  ///
  /// In en, this message translates to:
  /// **'Account Not Verified'**
  String get account_not_verified_title;

  /// No description provided for @account_not_verified_message.
  ///
  /// In en, this message translates to:
  /// **'Your account is not verified. Please check your email for the verification link.'**
  String get account_not_verified_message;

  /// No description provided for @resend_verification_email.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resend_verification_email;

  /// No description provided for @access_denied_title.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get access_denied_title;

  /// No description provided for @access_denied_message.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this section. Please wait until the system administrators grant you access.'**
  String get access_denied_message;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_password;

  /// No description provided for @enter_email_to_reset.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address to reset your password.'**
  String get enter_email_to_reset;

  /// No description provided for @reset_email_sent.
  ///
  /// In en, this message translates to:
  /// **'A password reset email has been sent. Please check your inbox.'**
  String get reset_email_sent;

  /// No description provided for @confirmEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A confirmation email has been sent. Please check your inbox.'**
  String get confirmEmailSent;

  /// No description provided for @searchBy.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email or phone number ...'**
  String get searchBy;

  /// No description provided for @searchByNameCode.
  ///
  /// In en, this message translates to:
  /// **'Search by name or code ...'**
  String get searchByNameCode;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage profile'**
  String get profile_subtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get myProfile;

  /// No description provided for @viewAndControlSystem.
  ///
  /// In en, this message translates to:
  /// **'View and Control System'**
  String get viewAndControlSystem;

  /// No description provided for @manageAndConfigureSystem.
  ///
  /// In en, this message translates to:
  /// **'Manage and Configure System'**
  String get manageAndConfigureSystem;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @complaints_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage complaints'**
  String get complaints_subtitle;

  /// No description provided for @viewComplaints.
  ///
  /// In en, this message translates to:
  /// **'View Complaints'**
  String get viewComplaints;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies;

  /// No description provided for @maintenanceContracts.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Contracts'**
  String get maintenanceContracts;

  /// No description provided for @systemStatusAndFaults.
  ///
  /// In en, this message translates to:
  /// **'System Status and Faults'**
  String get systemStatusAndFaults;

  /// No description provided for @selectUsers.
  ///
  /// In en, this message translates to:
  /// **'Seleect Users'**
  String get selectUsers;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @noUsersSelected.
  ///
  /// In en, this message translates to:
  /// **'No users selected'**
  String get noUsersSelected;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @masterAdmins.
  ///
  /// In en, this message translates to:
  /// **'Master Admins'**
  String get masterAdmins;

  /// No description provided for @admins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get admins;

  /// No description provided for @companyManagers.
  ///
  /// In en, this message translates to:
  /// **'Company Managers'**
  String get companyManagers;

  /// No description provided for @branchManagers.
  ///
  /// In en, this message translates to:
  /// **'Branch Managers'**
  String get branchManagers;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @noRoleUsers.
  ///
  /// In en, this message translates to:
  /// **'No Role Users'**
  String get noRoleUsers;

  /// No description provided for @masterAdmin.
  ///
  /// In en, this message translates to:
  /// **'Master Admin'**
  String get masterAdmin;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @companyManager.
  ///
  /// In en, this message translates to:
  /// **'Company Manager'**
  String get companyManager;

  /// No description provided for @branchManager.
  ///
  /// In en, this message translates to:
  /// **'Branch Manager'**
  String get branchManager;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @chooseRole.
  ///
  /// In en, this message translates to:
  /// **'Choose access role'**
  String get chooseRole;

  /// No description provided for @noRole.
  ///
  /// In en, this message translates to:
  /// **'No Role'**
  String get noRole;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @system_monitoring_control.
  ///
  /// In en, this message translates to:
  /// **'System Monitoring and Control'**
  String get system_monitoring_control;

  /// No description provided for @system_monitoring_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage system'**
  String get system_monitoring_card_subtitle;

  /// No description provided for @system_monitoring_description.
  ///
  /// In en, this message translates to:
  /// **'Monitor the current state of each sensor and control sub-units. You can also perform actions like turning devices on or off directly from this interface.'**
  String get system_monitoring_description;

  /// No description provided for @reportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show reports for maintenance contracts, visits and system status.'**
  String get reportsDescription;

  /// No description provided for @complaintsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show open compaints or submit new one.'**
  String get complaintsDescription;

  /// No description provided for @usersDescription.
  ///
  /// In en, this message translates to:
  /// **'Show and give or remove access from users'**
  String get usersDescription;

  /// No description provided for @branchesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add or remove branches'**
  String get branchesDescription;

  /// No description provided for @users_and_branches.
  ///
  /// In en, this message translates to:
  /// **'Users & Branches'**
  String get users_and_branches;

  /// No description provided for @users_and_branches_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage users & branches'**
  String get users_and_branches_subtitle;

  /// No description provided for @users_branches_hierarchy_title.
  ///
  /// In en, this message translates to:
  /// **'Users and Branches Hierarchy'**
  String get users_branches_hierarchy_title;

  /// No description provided for @users_branches_hierarchy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage users and branches hierarchy'**
  String get users_branches_hierarchy_subtitle;

  /// No description provided for @branches_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage branches'**
  String get branches_subtitle;

  /// No description provided for @companies_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage companies'**
  String get companies_subtitle;

  /// No description provided for @users_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage users'**
  String get users_subtitle;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Remove User'**
  String get deleteUser;

  /// No description provided for @changeAccessRole.
  ///
  /// In en, this message translates to:
  /// **'Modify Access Role'**
  String get changeAccessRole;

  /// No description provided for @confirmDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this user from the system?'**
  String get confirmDeleteUser;

  /// No description provided for @confirmChangeAccessRole.
  ///
  /// In en, this message translates to:
  /// **'Do you want to proceed with changing the user\'s access permissions?'**
  String get confirmChangeAccessRole;

  /// No description provided for @userDeletedSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'User has been successfully deleted from the system.'**
  String get userDeletedSuccessMessage;

  /// No description provided for @accessRoleChangedSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'User\'s access role has been successfully updated.'**
  String get accessRoleChangedSuccessMessage;

  /// No description provided for @companiesAndBranches.
  ///
  /// In en, this message translates to:
  /// **'Companies and Branches'**
  String get companiesAndBranches;

  /// No description provided for @companiesAndBranchesDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage companies and their branches. Add or remove companies and branches, and view detailed information about them.'**
  String get companiesAndBranchesDescription;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addNewMasterAdmin.
  ///
  /// In en, this message translates to:
  /// **'Add New Master Admin'**
  String get addNewMasterAdmin;

  /// No description provided for @addNewAdmin.
  ///
  /// In en, this message translates to:
  /// **'Add New Admin'**
  String get addNewAdmin;

  /// No description provided for @addNewCompanyManager.
  ///
  /// In en, this message translates to:
  /// **'Add New Company Manager'**
  String get addNewCompanyManager;

  /// No description provided for @addNewBranchManager.
  ///
  /// In en, this message translates to:
  /// **'Add New Branch Manager'**
  String get addNewBranchManager;

  /// No description provided for @addNewEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add New Employee'**
  String get addNewEmployee;

  /// No description provided for @addNewClient.
  ///
  /// In en, this message translates to:
  /// **'Add New Client'**
  String get addNewClient;

  /// No description provided for @noUsersToView.
  ///
  /// In en, this message translates to:
  /// **'No users to view.'**
  String get noUsersToView;

  /// No description provided for @noCompaneiesToAddCompanyManager.
  ///
  /// In en, this message translates to:
  /// **'There are no companies to add company managers to. Please add a company first.'**
  String get noCompaneiesToAddCompanyManager;

  /// No description provided for @noBranchesToAddBranchManager.
  ///
  /// In en, this message translates to:
  /// **'There are no branches to add branch managers to. Please add a branch first.'**
  String get noBranchesToAddBranchManager;

  /// No description provided for @noBranchesToAddEmployee.
  ///
  /// In en, this message translates to:
  /// **'There are no branches to add employees to. Please add a branch first.'**
  String get noBranchesToAddEmployee;

  /// No description provided for @noBranchesToAddClient.
  ///
  /// In en, this message translates to:
  /// **'There are no branches to add clients to. Please add a branch first.'**
  String get noBranchesToAddClient;

  /// No description provided for @not_authenticated.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in. To access this feature, please log in with your account.'**
  String get not_authenticated;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Fire Alarm System. Please login or sign up.'**
  String get welcome_message;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirm_password;

  /// No description provided for @don_t_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get don_t_have_an_account;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log In'**
  String get already_have_an_account;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Please choose a language'**
  String get select_language;

  /// No description provided for @login_with_google.
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get login_with_google;

  /// No description provided for @login_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Log in with Facebook'**
  String get login_with_facebook;

  /// No description provided for @signup_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signup_with_google;

  /// No description provided for @signup_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Facebook'**
  String get signup_with_facebook;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enter_name;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enter_phone_number;

  /// No description provided for @valid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get valid_phone_number;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enter_password;

  /// No description provided for @password_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get password_length;

  /// No description provided for @password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get password_mismatch;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get enter_email;

  /// No description provided for @valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get valid_email;

  /// No description provided for @logging_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Please wait while logging you in'**
  String get logging_in_progress;

  /// No description provided for @signup_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Please wait while creating your account'**
  String get signup_in_progress;

  /// No description provided for @wait_while_loading.
  ///
  /// In en, this message translates to:
  /// **'Pleae wait while loading data ...'**
  String get wait_while_loading;

  /// No description provided for @login_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please log in to your account to continue.'**
  String get login_welcome;

  /// No description provided for @signup_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Create a new account to join us and enjoy our services.'**
  String get signup_welcome;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @edit_information.
  ///
  /// In en, this message translates to:
  /// **'Edit Inforamation'**
  String get edit_information;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @info_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile info updated successfully'**
  String get info_updated;

  /// No description provided for @selectCompanies.
  ///
  /// In en, this message translates to:
  /// **'Select companies to view'**
  String get selectCompanies;

  /// No description provided for @allCompanies.
  ///
  /// In en, this message translates to:
  /// **'All companies'**
  String get allCompanies;

  /// No description provided for @noCompaniesSelected.
  ///
  /// In en, this message translates to:
  /// **'No companies selected'**
  String get noCompaniesSelected;

  /// No description provided for @noBranchesToView.
  ///
  /// In en, this message translates to:
  /// **'No branches to view'**
  String get noBranchesToView;

  /// No description provided for @noCompaniesToView.
  ///
  /// In en, this message translates to:
  /// **'No companies to view'**
  String get noCompaniesToView;

  /// No description provided for @noCompaniesToAddBranch.
  ///
  /// In en, this message translates to:
  /// **'There are no companies to add branches to. Please add a company first'**
  String get noCompaniesToAddBranch;

  /// No description provided for @branchInformation.
  ///
  /// In en, this message translates to:
  /// **'Branch Information'**
  String get branchInformation;

  /// No description provided for @companyInformation.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get companyInformation;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @addBranch.
  ///
  /// In en, this message translates to:
  /// **'Add New Branch'**
  String get addBranch;

  /// No description provided for @branchModified.
  ///
  /// In en, this message translates to:
  /// **'The branch details have been updated successfully.'**
  String get branchModified;

  /// No description provided for @branchAdded.
  ///
  /// In en, this message translates to:
  /// **'The branch has been added successfully.'**
  String get branchAdded;

  /// No description provided for @branchDeleted.
  ///
  /// In en, this message translates to:
  /// **'The branch has been deleted successfully.'**
  String get branchDeleted;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchName;

  /// No description provided for @editBranch.
  ///
  /// In en, this message translates to:
  /// **'Edit Branch'**
  String get editBranch;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @changeCompany.
  ///
  /// In en, this message translates to:
  /// **'Change Company'**
  String get changeCompany;

  /// No description provided for @deleteBranch.
  ///
  /// In en, this message translates to:
  /// **'Delete Branch'**
  String get deleteBranch;

  /// No description provided for @branchModifyWarning.
  ///
  /// In en, this message translates to:
  /// **'Please double-check the updated branch details before saving. Are you sure you want to proceed?'**
  String get branchModifyWarning;

  /// No description provided for @branchDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Deleting this branch is irreversible. Are you sure you want to proceed?'**
  String get branchDeleteWarning;

  /// No description provided for @yesDeleteBranch.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete branch'**
  String get yesDeleteBranch;

  /// No description provided for @yesSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Yes, save changes'**
  String get yesSaveChanges;

  /// No description provided for @noCancel.
  ///
  /// In en, this message translates to:
  /// **'No, cancel'**
  String get noCancel;

  /// No description provided for @waitDeltingBranch.
  ///
  /// In en, this message translates to:
  /// **'Please wait while deleting branch'**
  String get waitDeltingBranch;

  /// No description provided for @waitSavingBranch.
  ///
  /// In en, this message translates to:
  /// **'Please wait while saving branch information'**
  String get waitSavingBranch;

  /// No description provided for @enterBranchName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the branch name'**
  String get enterBranchName;

  /// No description provided for @enterBranchAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter the branch address'**
  String get enterBranchAddress;

  /// No description provided for @enterBranchPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter the branch phone number'**
  String get enterBranchPhone;

  /// No description provided for @enterBranchEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter the branch email address'**
  String get enterBranchEmail;

  /// No description provided for @enterBranchCompany.
  ///
  /// In en, this message translates to:
  /// **'Please choose a company for this branch'**
  String get enterBranchCompany;

  /// No description provided for @addCompany.
  ///
  /// In en, this message translates to:
  /// **'Add New Company'**
  String get addCompany;

  /// No description provided for @companyModified.
  ///
  /// In en, this message translates to:
  /// **'The company details have been updated successfully.'**
  String get companyModified;

  /// No description provided for @companyAdded.
  ///
  /// In en, this message translates to:
  /// **'The company has been added successfully.'**
  String get companyAdded;

  /// No description provided for @companyDeleted.
  ///
  /// In en, this message translates to:
  /// **'The company has been deleted successfully.'**
  String get companyDeleted;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @editCompany.
  ///
  /// In en, this message translates to:
  /// **'Edit Company'**
  String get editCompany;

  /// No description provided for @deleteCompany.
  ///
  /// In en, this message translates to:
  /// **'Delete Company'**
  String get deleteCompany;

  /// No description provided for @companyModifyWarning.
  ///
  /// In en, this message translates to:
  /// **'Please double-check the updated company details before saving. Are you sure you want to proceed?'**
  String get companyModifyWarning;

  /// No description provided for @companyDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Deleting this company is irreversible. Are you sure you want to proceed?'**
  String get companyDeleteWarning;

  /// No description provided for @yesDeleteCompany.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete company'**
  String get yesDeleteCompany;

  /// No description provided for @waitDeltingCompany.
  ///
  /// In en, this message translates to:
  /// **'Please wait while deleting company'**
  String get waitDeltingCompany;

  /// No description provided for @waitSavingCompany.
  ///
  /// In en, this message translates to:
  /// **'Please wait while saving company information'**
  String get waitSavingCompany;

  /// No description provided for @enterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the company name'**
  String get enterCompanyName;

  /// No description provided for @enterCompanyAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter the company address'**
  String get enterCompanyAddress;

  /// No description provided for @enterCompanyPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter the company phone number'**
  String get enterCompanyPhone;

  /// No description provided for @enterCompanyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter the company email address'**
  String get enterCompanyEmail;

  /// No description provided for @enterCompanyLogo.
  ///
  /// In en, this message translates to:
  /// **'Please add a logo for the company'**
  String get enterCompanyLogo;

  /// No description provided for @tabToAddLogo.
  ///
  /// In en, this message translates to:
  /// **'Tab to add company logo'**
  String get tabToAddLogo;

  /// No description provided for @logo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get logo;

  /// No description provided for @companyLogo.
  ///
  /// In en, this message translates to:
  /// **'Company Logo'**
  String get companyLogo;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'An error occured while choosing the image'**
  String get errorPickingImage;

  /// No description provided for @stepsToComplete.
  ///
  /// In en, this message translates to:
  /// **'To continue using the application, please complete the following steps:'**
  String get stepsToComplete;

  /// No description provided for @emailVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerificationTitle;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Your email has been successfully verified.'**
  String get emailVerified;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Your email is not verified. Click here to resend the verification email.'**
  String get emailNotVerified;

  /// No description provided for @phoneNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Phone Number'**
  String get phoneNumberTitle;

  /// No description provided for @phoneNumberAdded.
  ///
  /// In en, this message translates to:
  /// **'Your phone number has been added.'**
  String get phoneNumberAdded;

  /// No description provided for @phoneNumberNotAdded.
  ///
  /// In en, this message translates to:
  /// **'You have not added a phone number. Click here to add your phone number.'**
  String get phoneNumberNotAdded;

  /// No description provided for @accessRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Role'**
  String get accessRoleTitle;

  /// No description provided for @roleAssigned.
  ///
  /// In en, this message translates to:
  /// **'You have been assigned an access role.'**
  String get roleAssigned;

  /// No description provided for @roleNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an access role yet. Please wait for an administrator to grant you access.'**
  String get roleNotAssigned;

  /// No description provided for @tapToSelectUser.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a user'**
  String get tapToSelectUser;

  /// No description provided for @adminPermissions.
  ///
  /// In en, this message translates to:
  /// **'Admin Permissions'**
  String get adminPermissions;

  /// No description provided for @canUpdateAdmins.
  ///
  /// In en, this message translates to:
  /// **'Can update admins'**
  String get canUpdateAdmins;

  /// No description provided for @canUpdateCompanyManagers.
  ///
  /// In en, this message translates to:
  /// **'Can update company managers'**
  String get canUpdateCompanyManagers;

  /// No description provided for @canUpdateBranchManagers.
  ///
  /// In en, this message translates to:
  /// **'Can update branch managers'**
  String get canUpdateBranchManagers;

  /// No description provided for @canUpdateEmployees.
  ///
  /// In en, this message translates to:
  /// **'Can update employees'**
  String get canUpdateEmployees;

  /// No description provided for @canUpdateClients.
  ///
  /// In en, this message translates to:
  /// **'Can update clients'**
  String get canUpdateClients;

  /// No description provided for @canAddCompanies.
  ///
  /// In en, this message translates to:
  /// **'Can add companies'**
  String get canAddCompanies;

  /// No description provided for @canEditCompanies.
  ///
  /// In en, this message translates to:
  /// **'Can edit companies'**
  String get canEditCompanies;

  /// No description provided for @canDeleteCompanies.
  ///
  /// In en, this message translates to:
  /// **'Can delete companies'**
  String get canDeleteCompanies;

  /// No description provided for @canAddBranches.
  ///
  /// In en, this message translates to:
  /// **'Can add branches'**
  String get canAddBranches;

  /// No description provided for @canEditBranches.
  ///
  /// In en, this message translates to:
  /// **'Can edit branches'**
  String get canEditBranches;

  /// No description provided for @canDeleteBranches.
  ///
  /// In en, this message translates to:
  /// **'Can delete branches'**
  String get canDeleteBranches;

  /// No description provided for @invalid_custom_token.
  ///
  /// In en, this message translates to:
  /// **'The custom authentication token you provided is invalid. Please check and try again.'**
  String get invalid_custom_token;

  /// No description provided for @custom_token_mismatch.
  ///
  /// In en, this message translates to:
  /// **'The custom token provided does not match the expected format. Ensure it is correct.'**
  String get custom_token_mismatch;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'The email address entered is not valid. Please provide a valid email address.'**
  String get invalid_email;

  /// No description provided for @invalid_credential.
  ///
  /// In en, this message translates to:
  /// **'The credentials you provided are not recognized. Please check your login details.'**
  String get invalid_credential;

  /// No description provided for @user_disabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled by the administrator. Contact support for assistance.'**
  String get user_disabled;

  /// No description provided for @email_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email address. Please login or use a different email.'**
  String get email_already_in_use;

  /// No description provided for @wrong_password.
  ///
  /// In en, this message translates to:
  /// **'The password you entered is incorrect. Please try again.'**
  String get wrong_password;

  /// No description provided for @too_many_requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait for a while before trying again.'**
  String get too_many_requests;

  /// No description provided for @account_exists_with_different_credentials.
  ///
  /// In en, this message translates to:
  /// **'An account with this email exists but with different credentials. Try logging in with a different method.'**
  String get account_exists_with_different_credentials;

  /// No description provided for @requires_recent_login.
  ///
  /// In en, this message translates to:
  /// **'For security purposes, please log in again to continue.'**
  String get requires_recent_login;

  /// No description provided for @provider_already_linked.
  ///
  /// In en, this message translates to:
  /// **'This account is already linked to another authentication provider.'**
  String get provider_already_linked;

  /// No description provided for @no_such_provider.
  ///
  /// In en, this message translates to:
  /// **'The provider you are trying to use is not available for this account.'**
  String get no_such_provider;

  /// No description provided for @invalid_user_token.
  ///
  /// In en, this message translates to:
  /// **'The user token is invalid. Please log in again.'**
  String get invalid_user_token;

  /// No description provided for @user_token_expired.
  ///
  /// In en, this message translates to:
  /// **'The session has expired. Please log in again.'**
  String get user_token_expired;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'No user was found with this information. Please check your details.'**
  String get user_not_found;

  /// No description provided for @invalid_api_key.
  ///
  /// In en, this message translates to:
  /// **'The API key used is invalid. Contact support if the issue persists.'**
  String get invalid_api_key;

  /// No description provided for @credential_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'This credential is already in use with another account. Try a different login method.'**
  String get credential_already_in_use;

  /// No description provided for @operation_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'This operation is not allowed. Contact the administrator for more information.'**
  String get operation_not_allowed;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'The password entered is too weak. Use a stronger password with more characters.'**
  String get weak_password;

  /// No description provided for @app_not_authorized.
  ///
  /// In en, this message translates to:
  /// **'This app is not authorized to access the Firebase project. Contact the administrator.'**
  String get app_not_authorized;

  /// No description provided for @expired_action_code.
  ///
  /// In en, this message translates to:
  /// **'This action code has expired. Request a new one to proceed.'**
  String get expired_action_code;

  /// No description provided for @invalid_action_code.
  ///
  /// In en, this message translates to:
  /// **'The action code provided is invalid or has already been used.'**
  String get invalid_action_code;

  /// No description provided for @invalid_message_payload.
  ///
  /// In en, this message translates to:
  /// **'The message payload is invalid. Please contact support.'**
  String get invalid_message_payload;

  /// No description provided for @invalid_sender.
  ///
  /// In en, this message translates to:
  /// **'The sender is not authorized. Please ensure you are using a valid email.'**
  String get invalid_sender;

  /// No description provided for @invalid_recipient_email.
  ///
  /// In en, this message translates to:
  /// **'The recipient email address is invalid. Please check and try again.'**
  String get invalid_recipient_email;

  /// No description provided for @unauthorized_domain.
  ///
  /// In en, this message translates to:
  /// **'The domain you are trying to use is not authorized. Contact support for further details.'**
  String get unauthorized_domain;

  /// No description provided for @invalid_continue_uri.
  ///
  /// In en, this message translates to:
  /// **'The continue URL provided is invalid.'**
  String get invalid_continue_uri;

  /// No description provided for @missing_continue_uri.
  ///
  /// In en, this message translates to:
  /// **'A continue URL is required but missing. Please provide one.'**
  String get missing_continue_uri;

  /// No description provided for @missing_email.
  ///
  /// In en, this message translates to:
  /// **'The email field is required. Please provide an email address.'**
  String get missing_email;

  /// No description provided for @missing_phone_number.
  ///
  /// In en, this message translates to:
  /// **'The phone number field is required. Please provide a phone number.'**
  String get missing_phone_number;

  /// No description provided for @invalid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'The phone number entered is invalid. Please provide a valid phone number.'**
  String get invalid_phone_number;

  /// No description provided for @missing_verification_code.
  ///
  /// In en, this message translates to:
  /// **'The verification code is missing. Please enter the code sent to you.'**
  String get missing_verification_code;

  /// No description provided for @invalid_verification_code.
  ///
  /// In en, this message translates to:
  /// **'The verification code entered is invalid. Please try again.'**
  String get invalid_verification_code;

  /// No description provided for @missing_verification_id.
  ///
  /// In en, this message translates to:
  /// **'The verification ID is missing. Please try the process again.'**
  String get missing_verification_id;

  /// No description provided for @invalid_verification_id.
  ///
  /// In en, this message translates to:
  /// **'The verification ID entered is invalid. Please try again.'**
  String get invalid_verification_id;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'The session has expired. Please log in again.'**
  String get session_expired;

  /// No description provided for @quota_exceeded.
  ///
  /// In en, this message translates to:
  /// **'The quota for this operation has been exceeded. Try again later.'**
  String get quota_exceeded;

  /// No description provided for @missing_app_credential.
  ///
  /// In en, this message translates to:
  /// **'The app credential is missing. Please try again.'**
  String get missing_app_credential;

  /// No description provided for @invalid_app_credential.
  ///
  /// In en, this message translates to:
  /// **'The app credential entered is invalid.'**
  String get invalid_app_credential;

  /// No description provided for @missing_client_identifier.
  ///
  /// In en, this message translates to:
  /// **'The client identifier is missing.'**
  String get missing_client_identifier;

  /// No description provided for @tenant_id_mismatch.
  ///
  /// In en, this message translates to:
  /// **'The tenant ID does not match the expected value.'**
  String get tenant_id_mismatch;

  /// No description provided for @unsupported_tenant_operation.
  ///
  /// In en, this message translates to:
  /// **'This operation is not supported for this tenant.'**
  String get unsupported_tenant_operation;

  /// No description provided for @user_mismatch.
  ///
  /// In en, this message translates to:
  /// **'The logged-in user does not match the expected user.'**
  String get user_mismatch;

  /// No description provided for @network_request_failed.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred. Please check your connection and try again.'**
  String get network_request_failed;

  /// No description provided for @no_signed_in_user.
  ///
  /// In en, this message translates to:
  /// **'No user is signed in. Please log in to continue.'**
  String get no_signed_in_user;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'The operation was cancelled. Please try again.'**
  String get cancelled;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again later.'**
  String get unknown_error;

  /// No description provided for @invalid_argument.
  ///
  /// In en, this message translates to:
  /// **'An invalid argument was provided. Please check your input.'**
  String get invalid_argument;

  /// No description provided for @deadline_exceeded.
  ///
  /// In en, this message translates to:
  /// **'The operation took too long to complete. Please try again later.'**
  String get deadline_exceeded;

  /// No description provided for @not_found.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get not_found;

  /// No description provided for @already_exists.
  ///
  /// In en, this message translates to:
  /// **'The resource already exists.'**
  String get already_exists;

  /// No description provided for @permission_denied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get permission_denied;

  /// No description provided for @resource_exhausted.
  ///
  /// In en, this message translates to:
  /// **'Resource limit exceeded. Please try again later.'**
  String get resource_exhausted;

  /// No description provided for @failed_precondition.
  ///
  /// In en, this message translates to:
  /// **'The operation cannot be performed due to failed precondition.'**
  String get failed_precondition;

  /// No description provided for @aborted.
  ///
  /// In en, this message translates to:
  /// **'The operation was aborted due to a conflict.'**
  String get aborted;

  /// No description provided for @out_of_range.
  ///
  /// In en, this message translates to:
  /// **'The provided value is out of the acceptable range.'**
  String get out_of_range;

  /// No description provided for @unimplemented.
  ///
  /// In en, this message translates to:
  /// **'This operation is not implemented or supported.'**
  String get unimplemented;

  /// No description provided for @internal.
  ///
  /// In en, this message translates to:
  /// **'An internal error occurred. Please try again later.'**
  String get internal;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is currently unavailable. Please check your connection or try again later.'**
  String get unavailable;

  /// No description provided for @data_loss.
  ///
  /// In en, this message translates to:
  /// **'Data loss occurred. Please try again later.'**
  String get data_loss;

  /// No description provided for @unauthenticated.
  ///
  /// In en, this message translates to:
  /// **'You need to sign in to perform this action.'**
  String get unauthenticated;

  /// No description provided for @sign_in_failed.
  ///
  /// In en, this message translates to:
  /// **'The sign-in attempt has failed. Please try again later or contact support if the issue persists.'**
  String get sign_in_failed;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred during sign-in. Please check your internet connection and try again.'**
  String get network_error;

  /// No description provided for @sign_in_cancelled.
  ///
  /// In en, this message translates to:
  /// **'The sign-in process was cancelled. Please try again if you want to continue.'**
  String get sign_in_cancelled;

  /// No description provided for @sign_in_required.
  ///
  /// In en, this message translates to:
  /// **'You need to sign in to proceed. Please sign in and try again.'**
  String get sign_in_required;

  /// No description provided for @contract_wait_employee_sign_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You must sign first to activate the contract.'**
  String get contract_wait_employee_sign_subtitle;

  /// No description provided for @contract_wait_other_client_sign_title.
  ///
  /// In en, this message translates to:
  /// **'Waiting for client signature'**
  String get contract_wait_other_client_sign_title;

  /// No description provided for @contract_wait_other_client_sign_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the client signature to activate the contract.'**
  String get contract_wait_other_client_sign_subtitle;

  /// No description provided for @contract_active_title.
  ///
  /// In en, this message translates to:
  /// **'Contract Active'**
  String get contract_active_title;

  /// No description provided for @contract_active_until.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String contract_active_until(Object date);

  /// No description provided for @contract_expired_title.
  ///
  /// In en, this message translates to:
  /// **'Contract Expired'**
  String get contract_expired_title;

  /// No description provided for @contract_expired_since.
  ///
  /// In en, this message translates to:
  /// **'Expired on {date}'**
  String contract_expired_since(Object date);

  /// No description provided for @snackbar_signing_not_enabled.
  ///
  /// In en, this message translates to:
  /// **'Signing is not enabled yet'**
  String get snackbar_signing_not_enabled;

  /// No description provided for @snackbar_client_notification_not_enabled.
  ///
  /// In en, this message translates to:
  /// **'Client notification is not enabled yet'**
  String get snackbar_client_notification_not_enabled;

  /// No description provided for @signature_employee_title.
  ///
  /// In en, this message translates to:
  /// **'Employee Signature'**
  String get signature_employee_title;

  /// No description provided for @signature_client_title.
  ///
  /// In en, this message translates to:
  /// **'Client Signature'**
  String get signature_client_title;

  /// No description provided for @signature_confirm_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm {title}'**
  String signature_confirm_dialog_title(Object title);

  /// No description provided for @signature_confirm_dialog_body.
  ///
  /// In en, this message translates to:
  /// **'By confirming, your signature will be recorded on this contract. This action cannot be undone.'**
  String get signature_confirm_dialog_body;

  /// No description provided for @slide_to_confirm.
  ///
  /// In en, this message translates to:
  /// **'Slide to confirm'**
  String get slide_to_confirm;

  /// No description provided for @linear_stage_draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get linear_stage_draft;

  /// No description provided for @linear_stage_employee_signed.
  ///
  /// In en, this message translates to:
  /// **'Employee Signed'**
  String get linear_stage_employee_signed;

  /// No description provided for @linear_stage_client_signed.
  ///
  /// In en, this message translates to:
  /// **'Client Signed'**
  String get linear_stage_client_signed;

  /// No description provided for @linear_stage_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get linear_stage_active;

  /// No description provided for @linear_stage_expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get linear_stage_expired;

  /// No description provided for @contract_number_prefix.
  ///
  /// In en, this message translates to:
  /// **'Contract No: {number}'**
  String contract_number_prefix(Object number);

  /// No description provided for @contract_label.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract_label;

  /// No description provided for @period_from.
  ///
  /// In en, this message translates to:
  /// **'Active from '**
  String get period_from;

  /// No description provided for @period_to.
  ///
  /// In en, this message translates to:
  /// **' to '**
  String get period_to;

  /// No description provided for @employee_label.
  ///
  /// In en, this message translates to:
  /// **'Employee: '**
  String get employee_label;

  /// No description provided for @client_label.
  ///
  /// In en, this message translates to:
  /// **'Client: '**
  String get client_label;

  /// No description provided for @branch_label.
  ///
  /// In en, this message translates to:
  /// **'Branch: '**
  String get branch_label;

  /// No description provided for @sign_employee_required_title.
  ///
  /// In en, this message translates to:
  /// **'Employee signature required'**
  String get sign_employee_required_title;

  /// No description provided for @sign_employee_required_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You must sign first so the client can sign.'**
  String get sign_employee_required_subtitle;

  /// No description provided for @waiting_employee_signature_title.
  ///
  /// In en, this message translates to:
  /// **'Waiting for employee signature'**
  String get waiting_employee_signature_title;

  /// No description provided for @waiting_employee_signature_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the employee signature so the client can sign.'**
  String get waiting_employee_signature_subtitle;

  /// No description provided for @sign_client_required_title.
  ///
  /// In en, this message translates to:
  /// **'Client signature required'**
  String get sign_client_required_title;

  /// No description provided for @view_contract.
  ///
  /// In en, this message translates to:
  /// **'View Contract'**
  String get view_contract;

  /// No description provided for @view_contract_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View contract details and export to PDF'**
  String get view_contract_subtitle;

  /// No description provided for @new_visit_report.
  ///
  /// In en, this message translates to:
  /// **'Add Visit Report'**
  String get new_visit_report;

  /// No description provided for @new_visit_report_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add new visit report'**
  String get new_visit_report_subtitle;

  /// No description provided for @new_contract.
  ///
  /// In en, this message translates to:
  /// **'Add Contract'**
  String get new_contract;

  /// No description provided for @new_new_contract_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add new contract'**
  String get new_new_contract_subtitle;

  /// No description provided for @visit_reports.
  ///
  /// In en, this message translates to:
  /// **'Visit Reports'**
  String get visit_reports;

  /// No description provided for @visit_reports_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View visit details and export to PDF'**
  String get visit_reports_subtitle;

  /// No description provided for @emergency_visit_request.
  ///
  /// In en, this message translates to:
  /// **'Request Emergency Visit'**
  String get emergency_visit_request;

  /// No description provided for @emergency_visit_request_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Request emergency visit'**
  String get emergency_visit_request_subtitle;

  /// No description provided for @contracts.
  ///
  /// In en, this message translates to:
  /// **'Contracts'**
  String get contracts;

  /// No description provided for @no_contracts_yet.
  ///
  /// In en, this message translates to:
  /// **'There are no contracts yet!'**
  String get no_contracts_yet;

  /// No description provided for @reports_contracts_title.
  ///
  /// In en, this message translates to:
  /// **'Reports & Contracts'**
  String get reports_contracts_title;

  /// No description provided for @reports_contracts_card_title.
  ///
  /// In en, this message translates to:
  /// **'Contracts & Reports'**
  String get reports_contracts_card_title;

  /// No description provided for @reports_contracts_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage contracts and visit reports, submit emergency requests or complaints.'**
  String get reports_contracts_card_subtitle;

  /// No description provided for @reports_contracts_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage reports & contracts'**
  String get reports_contracts_subtitle;

  /// No description provided for @contract_components.
  ///
  /// In en, this message translates to:
  /// **'Contract Components'**
  String get contract_components;

  /// No description provided for @contract_components_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update contract components'**
  String get contract_components_subtitle;

  /// No description provided for @offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offline_mode;

  /// No description provided for @offline_mode_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage system in offline mode'**
  String get offline_mode_subtitle;

  /// No description provided for @share_contract.
  ///
  /// In en, this message translates to:
  /// **'Share Contract'**
  String get share_contract;

  /// No description provided for @share_contract_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Share contract with other employees or clients'**
  String get share_contract_subtitle;

  /// No description provided for @share_with.
  ///
  /// In en, this message translates to:
  /// **'Share with'**
  String get share_with;

  /// No description provided for @no_users.
  ///
  /// In en, this message translates to:
  /// **'No users'**
  String get no_users;

  /// No description provided for @contract_sharing_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Contract sharing updated successfully.'**
  String get contract_sharing_updated_success;

  /// No description provided for @contract_signed_success.
  ///
  /// In en, this message translates to:
  /// **'Contract signed successfully.'**
  String get contract_signed_success;

  /// No description provided for @emergency_visits.
  ///
  /// In en, this message translates to:
  /// **'Emergency Visits'**
  String get emergency_visits;

  /// No description provided for @emergency_visits_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View emergency visits or request a new one'**
  String get emergency_visits_subtitle;

  /// No description provided for @feature_not_supported_yet.
  ///
  /// In en, this message translates to:
  /// **'Feature not supported yet'**
  String get feature_not_supported_yet;

  /// No description provided for @suitable.
  ///
  /// In en, this message translates to:
  /// **'Suitable'**
  String get suitable;

  /// No description provided for @unsuitable.
  ///
  /// In en, this message translates to:
  /// **'Unsuitable'**
  String get unsuitable;

  /// No description provided for @system_report_no.
  ///
  /// In en, this message translates to:
  /// **'System Report No. {number}'**
  String system_report_no(Object number);

  /// No description provided for @emergency_visit_request_no.
  ///
  /// In en, this message translates to:
  /// **'Request No. {number}'**
  String emergency_visit_request_no(Object number);

  /// No description provided for @visit_date.
  ///
  /// In en, this message translates to:
  /// **'Visit Date: '**
  String get visit_date;

  /// No description provided for @system_status.
  ///
  /// In en, this message translates to:
  /// **'System Status: '**
  String get system_status;

  /// No description provided for @signed.
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get signed;

  /// No description provided for @not_signed.
  ///
  /// In en, this message translates to:
  /// **'Not Signed'**
  String get not_signed;

  /// No description provided for @visit_report_signed_success.
  ///
  /// In en, this message translates to:
  /// **'Visit report signed successfully.'**
  String get visit_report_signed_success;

  /// No description provided for @notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View notifications'**
  String get notifications_subtitle;

  /// No description provided for @view_visit_report.
  ///
  /// In en, this message translates to:
  /// **'View Visit Report'**
  String get view_visit_report;

  /// No description provided for @signature_confirm_dialog_body_visit_report.
  ///
  /// In en, this message translates to:
  /// **'By confirming, your signature will be recorded on this visit report. This action cannot be undone.'**
  String get signature_confirm_dialog_body_visit_report;

  /// No description provided for @visit_report_wait_client_sign_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign the visit report to proceed.'**
  String get visit_report_wait_client_sign_subtitle;

  /// No description provided for @visit_report_wait_other_client_sign_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the client signature to complete the visit report.'**
  String get visit_report_wait_other_client_sign_subtitle;

  /// No description provided for @firstPartyInformation.
  ///
  /// In en, this message translates to:
  /// **'First Party Information'**
  String get firstPartyInformation;

  /// No description provided for @firstPartyName.
  ///
  /// In en, this message translates to:
  /// **'First Party Name'**
  String get firstPartyName;

  /// No description provided for @firstPartyRepresentativeName.
  ///
  /// In en, this message translates to:
  /// **'First Party Representative Name'**
  String get firstPartyRepresentativeName;

  /// No description provided for @firstPartyAddress.
  ///
  /// In en, this message translates to:
  /// **'First Party Address'**
  String get firstPartyAddress;

  /// No description provided for @firstPartyCommercialRecord.
  ///
  /// In en, this message translates to:
  /// **'First Party Commercial Record'**
  String get firstPartyCommercialRecord;

  /// No description provided for @firstPartyG.
  ///
  /// In en, this message translates to:
  /// **'First Party G'**
  String get firstPartyG;

  /// No description provided for @firstPartyIdNumber.
  ///
  /// In en, this message translates to:
  /// **'First Party ID Number'**
  String get firstPartyIdNumber;

  /// No description provided for @firstPartySignature.
  ///
  /// In en, this message translates to:
  /// **'First Party Signature'**
  String get firstPartySignature;

  /// No description provided for @tapToUploadSignature.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload signature'**
  String get tapToUploadSignature;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @representativeName.
  ///
  /// In en, this message translates to:
  /// **'Representative Name'**
  String get representativeName;

  /// No description provided for @commercialRecord.
  ///
  /// In en, this message translates to:
  /// **'Commercial Record'**
  String get commercialRecord;

  /// No description provided for @g.
  ///
  /// In en, this message translates to:
  /// **'G'**
  String get g;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @noSignatureAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No signature added yet'**
  String get noSignatureAddedYet;

  /// No description provided for @time_now_long.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get time_now_long;

  /// No description provided for @time_now_short.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get time_now_short;

  /// No description provided for @time_min_long.
  ///
  /// In en, this message translates to:
  /// **'{n} min ago'**
  String time_min_long(int n);

  /// No description provided for @time_min_short.
  ///
  /// In en, this message translates to:
  /// **'{n}m'**
  String time_min_short(int n);

  /// No description provided for @time_hour_long.
  ///
  /// In en, this message translates to:
  /// **'{n} hour ago'**
  String time_hour_long(int n);

  /// No description provided for @time_hour_short.
  ///
  /// In en, this message translates to:
  /// **'{n}h'**
  String time_hour_short(int n);

  /// No description provided for @time_day_long.
  ///
  /// In en, this message translates to:
  /// **'{n} day ago'**
  String time_day_long(int n);

  /// No description provided for @time_day_short.
  ///
  /// In en, this message translates to:
  /// **'{n}d'**
  String time_day_short(int n);

  /// No description provided for @time_week_long.
  ///
  /// In en, this message translates to:
  /// **'{n} week ago'**
  String time_week_long(int n);

  /// No description provided for @time_week_short.
  ///
  /// In en, this message translates to:
  /// **'{n}w'**
  String time_week_short(int n);

  /// No description provided for @time_month_long.
  ///
  /// In en, this message translates to:
  /// **'{n} month ago'**
  String time_month_long(int n);

  /// No description provided for @time_month_short.
  ///
  /// In en, this message translates to:
  /// **'{n}mo'**
  String time_month_short(int n);

  /// No description provided for @time_year_long.
  ///
  /// In en, this message translates to:
  /// **'{n} year ago'**
  String time_year_long(int n);

  /// No description provided for @time_year_short.
  ///
  /// In en, this message translates to:
  /// **'{n}y'**
  String time_year_short(int n);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
