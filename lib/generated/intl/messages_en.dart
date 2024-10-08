// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aborted": MessageLookupByLibrary.simpleMessage(
            "The operation was aborted due to a conflict."),
        "accessRoleChangedSuccessMessage": MessageLookupByLibrary.simpleMessage(
            "User\'s access role has been successfully updated."),
        "access_denied_message": MessageLookupByLibrary.simpleMessage(
            "You do not have access to this section. Please wait until the system administrators grant you access."),
        "access_denied_title":
            MessageLookupByLibrary.simpleMessage("Access Denied"),
        "account_exists_with_different_credentials":
            MessageLookupByLibrary.simpleMessage(
                "An account with this email exists but with different credentials. Try logging in with a different method."),
        "account_not_verified_message": MessageLookupByLibrary.simpleMessage(
            "Your account is not verified. Please check your email for the verification link."),
        "account_not_verified_title":
            MessageLookupByLibrary.simpleMessage("Account Not Verified"),
        "addNewAdmin": MessageLookupByLibrary.simpleMessage("Add New Admin"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "admins": MessageLookupByLibrary.simpleMessage("Admins"),
        "already_exists": MessageLookupByLibrary.simpleMessage(
            "The resource already exists."),
        "already_have_an_account": MessageLookupByLibrary.simpleMessage(
            "Already have an account? Log In"),
        "app_name":
            MessageLookupByLibrary.simpleMessage("Smart Fire Alarm System"),
        "app_not_authorized": MessageLookupByLibrary.simpleMessage(
            "This app is not authorized to access the Firebase project. Contact the administrator."),
        "branchManager": MessageLookupByLibrary.simpleMessage("Branch Manager"),
        "branchManagers":
            MessageLookupByLibrary.simpleMessage("Branch Managers"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelled": MessageLookupByLibrary.simpleMessage(
            "The operation was cancelled. Please try again."),
        "changeAccessRole":
            MessageLookupByLibrary.simpleMessage("Modify Access Role"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change Language"),
        "change_password":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "client": MessageLookupByLibrary.simpleMessage("Client"),
        "clients": MessageLookupByLibrary.simpleMessage("Clients"),
        "complaints": MessageLookupByLibrary.simpleMessage("Complaints"),
        "complaintsDescription": MessageLookupByLibrary.simpleMessage(
            "Show open compaints or submit new one."),
        "confirmChangeAccessRole": MessageLookupByLibrary.simpleMessage(
            "Do you want to proceed with changing the user\'s access permissions?"),
        "confirmDeleteUser": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to permanently delete this user from the system?"),
        "confirm_password": MessageLookupByLibrary.simpleMessage(
            "Please confirm your password"),
        "continue_with_google":
            MessageLookupByLibrary.simpleMessage("Continue with Google"),
        "credential_already_in_use": MessageLookupByLibrary.simpleMessage(
            "This credential is already in use with another account. Try a different login method."),
        "custom_token_mismatch": MessageLookupByLibrary.simpleMessage(
            "The custom token provided does not match the expected format. Ensure it is correct."),
        "data_loss": MessageLookupByLibrary.simpleMessage(
            "Data loss occurred. Please try again later."),
        "deadline_exceeded": MessageLookupByLibrary.simpleMessage(
            "The operation took too long to complete. Please try again later."),
        "deleteUser": MessageLookupByLibrary.simpleMessage("Remove User"),
        "don_t_have_an_account": MessageLookupByLibrary.simpleMessage(
            "Don\'t have an account? Sign Up"),
        "edit_information":
            MessageLookupByLibrary.simpleMessage("Edit Inforamation"),
        "email": MessageLookupByLibrary.simpleMessage("Email Address"),
        "email_already_in_use": MessageLookupByLibrary.simpleMessage(
            "An account already exists with this email address. Please login or use a different email."),
        "employee": MessageLookupByLibrary.simpleMessage("Employee"),
        "employees": MessageLookupByLibrary.simpleMessage("Employees"),
        "enter_email": MessageLookupByLibrary.simpleMessage(
            "Please enter your email address"),
        "enter_email_to_reset": MessageLookupByLibrary.simpleMessage(
            "Please enter your email address to reset your password."),
        "enter_name":
            MessageLookupByLibrary.simpleMessage("Please enter your name"),
        "enter_password":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "enter_phone_number": MessageLookupByLibrary.simpleMessage(
            "Please enter your phone number"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "expired_action_code": MessageLookupByLibrary.simpleMessage(
            "This action code has expired. Request a new one to proceed."),
        "failed_precondition": MessageLookupByLibrary.simpleMessage(
            "The operation cannot be performed due to failed precondition."),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot your password?"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "info_updated": MessageLookupByLibrary.simpleMessage(
            "Profile info updated successfully"),
        "internal": MessageLookupByLibrary.simpleMessage(
            "An internal error occurred. Please try again later."),
        "invalid_action_code": MessageLookupByLibrary.simpleMessage(
            "The action code provided is invalid or has already been used."),
        "invalid_api_key": MessageLookupByLibrary.simpleMessage(
            "The API key used is invalid. Contact support if the issue persists."),
        "invalid_app_credential": MessageLookupByLibrary.simpleMessage(
            "The app credential entered is invalid."),
        "invalid_argument": MessageLookupByLibrary.simpleMessage(
            "An invalid argument was provided. Please check your input."),
        "invalid_continue_uri": MessageLookupByLibrary.simpleMessage(
            "The continue URL provided is invalid."),
        "invalid_credential": MessageLookupByLibrary.simpleMessage(
            "The credentials you provided are not recognized. Please check your login details."),
        "invalid_custom_token": MessageLookupByLibrary.simpleMessage(
            "The custom authentication token you provided is invalid. Please check and try again."),
        "invalid_email": MessageLookupByLibrary.simpleMessage(
            "The email address entered is not valid. Please provide a valid email address."),
        "invalid_message_payload": MessageLookupByLibrary.simpleMessage(
            "The message payload is invalid. Please contact support."),
        "invalid_phone_number": MessageLookupByLibrary.simpleMessage(
            "The phone number entered is invalid. Please provide a valid phone number."),
        "invalid_recipient_email": MessageLookupByLibrary.simpleMessage(
            "The recipient email address is invalid. Please check and try again."),
        "invalid_sender": MessageLookupByLibrary.simpleMessage(
            "The sender is not authorized. Please ensure you are using a valid email."),
        "invalid_user_token": MessageLookupByLibrary.simpleMessage(
            "The user token is invalid. Please log in again."),
        "invalid_verification_code": MessageLookupByLibrary.simpleMessage(
            "The verification code entered is invalid. Please try again."),
        "invalid_verification_id": MessageLookupByLibrary.simpleMessage(
            "The verification ID entered is invalid. Please try again."),
        "logging_in_progress": MessageLookupByLibrary.simpleMessage(
            "Please wait while logging you in"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "login_welcome": MessageLookupByLibrary.simpleMessage(
            "Welcome back! Please log in to your account to continue."),
        "login_with_facebook":
            MessageLookupByLibrary.simpleMessage("Log in with Facebook"),
        "login_with_google":
            MessageLookupByLibrary.simpleMessage("Log in with Google"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "maintenanceContracts":
            MessageLookupByLibrary.simpleMessage("Maintenance Contracts"),
        "manageAndConfigureSystem":
            MessageLookupByLibrary.simpleMessage("Manage and Configure System"),
        "missing_app_credential": MessageLookupByLibrary.simpleMessage(
            "The app credential is missing. Please try again."),
        "missing_client_identifier": MessageLookupByLibrary.simpleMessage(
            "The client identifier is missing."),
        "missing_continue_uri": MessageLookupByLibrary.simpleMessage(
            "A continue URL is required but missing. Please provide one."),
        "missing_email": MessageLookupByLibrary.simpleMessage(
            "The email field is required. Please provide an email address."),
        "missing_phone_number": MessageLookupByLibrary.simpleMessage(
            "The phone number field is required. Please provide a phone number."),
        "missing_verification_code": MessageLookupByLibrary.simpleMessage(
            "The verification code is missing. Please enter the code sent to you."),
        "missing_verification_id": MessageLookupByLibrary.simpleMessage(
            "The verification ID is missing. Please try the process again."),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "network_error": MessageLookupByLibrary.simpleMessage(
            "A network error occurred during sign-in. Please check your internet connection and try again."),
        "network_request_failed": MessageLookupByLibrary.simpleMessage(
            "A network error occurred. Please check your connection and try again."),
        "noRole": MessageLookupByLibrary.simpleMessage("No Role"),
        "no_signed_in_user": MessageLookupByLibrary.simpleMessage(
            "No user is signed in. Please log in to continue."),
        "no_such_provider": MessageLookupByLibrary.simpleMessage(
            "The provider you are trying to use is not available for this account."),
        "not_authenticated": MessageLookupByLibrary.simpleMessage(
            "You are not logged in. To access this feature, please log in with your account."),
        "not_found": MessageLookupByLibrary.simpleMessage(
            "The requested resource was not found."),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "operation_not_allowed": MessageLookupByLibrary.simpleMessage(
            "This operation is not allowed. Contact the administrator for more information."),
        "or": MessageLookupByLibrary.simpleMessage("or"),
        "out_of_range": MessageLookupByLibrary.simpleMessage(
            "The provided value is out of the acceptable range."),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "password_length": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters long"),
        "password_mismatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "permission_denied": MessageLookupByLibrary.simpleMessage(
            "You do not have permission to perform this action."),
        "phone": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "provider_already_linked": MessageLookupByLibrary.simpleMessage(
            "This account is already linked to another authentication provider."),
        "quota_exceeded": MessageLookupByLibrary.simpleMessage(
            "The quota for this operation has been exceeded. Try again later."),
        "regionalManager":
            MessageLookupByLibrary.simpleMessage("Regional Manager"),
        "regionalManagers":
            MessageLookupByLibrary.simpleMessage("Regional Managers"),
        "reports": MessageLookupByLibrary.simpleMessage("Reports"),
        "reportsDescription": MessageLookupByLibrary.simpleMessage(
            "Show reports for maintenance contracts, visits and system status."),
        "requires_recent_login": MessageLookupByLibrary.simpleMessage(
            "For security purposes, please log in again to continue."),
        "resend_verification_email":
            MessageLookupByLibrary.simpleMessage("Resend Verification Email"),
        "reset_email_sent": MessageLookupByLibrary.simpleMessage(
            "A password reset email has been sent. Please check your inbox."),
        "resource_exhausted": MessageLookupByLibrary.simpleMessage(
            "Resource limit exceeded. Please try again later."),
        "role": MessageLookupByLibrary.simpleMessage("Role"),
        "save_changes": MessageLookupByLibrary.simpleMessage("Save Changes"),
        "select_language":
            MessageLookupByLibrary.simpleMessage("Please choose a language"),
        "session_expired": MessageLookupByLibrary.simpleMessage(
            "The session has expired. Please log in again."),
        "sign_in_cancelled": MessageLookupByLibrary.simpleMessage(
            "The sign-in process was cancelled. Please try again if you want to continue."),
        "sign_in_failed": MessageLookupByLibrary.simpleMessage(
            "The sign-in attempt has failed. Please try again later or contact support if the issue persists."),
        "sign_in_required": MessageLookupByLibrary.simpleMessage(
            "You need to sign in to proceed. Please sign in and try again."),
        "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signup_in_progress": MessageLookupByLibrary.simpleMessage(
            "Please wait while creating your account"),
        "signup_welcome": MessageLookupByLibrary.simpleMessage(
            "Welcome! Create a new account to join us and enjoy our services."),
        "signup_with_facebook":
            MessageLookupByLibrary.simpleMessage("Sign up with Facebook"),
        "signup_with_google":
            MessageLookupByLibrary.simpleMessage("Sign up with Google"),
        "submitComplaint":
            MessageLookupByLibrary.simpleMessage("Submit Complaint"),
        "system": MessageLookupByLibrary.simpleMessage("System"),
        "systemStatusAndFaults":
            MessageLookupByLibrary.simpleMessage("System Status and Faults"),
        "system_monitoring_control": MessageLookupByLibrary.simpleMessage(
            "System Monitoring and Control"),
        "system_monitoring_description": MessageLookupByLibrary.simpleMessage(
            "Monitor the current state of each sensor and control sub-units. You can also perform actions like turning devices on or off directly from this interface."),
        "technican": MessageLookupByLibrary.simpleMessage("Technician"),
        "technicans": MessageLookupByLibrary.simpleMessage("Technicians"),
        "tenant_id_mismatch": MessageLookupByLibrary.simpleMessage(
            "The tenant ID does not match the expected value."),
        "too_many_requests": MessageLookupByLibrary.simpleMessage(
            "Too many requests. Please wait for a while before trying again."),
        "unauthenticated": MessageLookupByLibrary.simpleMessage(
            "You need to sign in to perform this action."),
        "unauthorized_domain": MessageLookupByLibrary.simpleMessage(
            "The domain you are trying to use is not authorized. Contact support for further details."),
        "unavailable": MessageLookupByLibrary.simpleMessage(
            "The service is currently unavailable. Please check your connection or try again later."),
        "unimplemented": MessageLookupByLibrary.simpleMessage(
            "This operation is not implemented or supported."),
        "unknown_error": MessageLookupByLibrary.simpleMessage(
            "An unknown error occurred. Please try again later."),
        "unsupported_tenant_operation": MessageLookupByLibrary.simpleMessage(
            "This operation is not supported for this tenant."),
        "userDeletedSuccessMessage": MessageLookupByLibrary.simpleMessage(
            "User has been successfully deleted from the system."),
        "user_disabled": MessageLookupByLibrary.simpleMessage(
            "This account has been disabled by the administrator. Contact support for assistance."),
        "user_mismatch": MessageLookupByLibrary.simpleMessage(
            "The logged-in user does not match the expected user."),
        "user_not_found": MessageLookupByLibrary.simpleMessage(
            "No user was found with this information. Please check your details."),
        "user_token_expired": MessageLookupByLibrary.simpleMessage(
            "The session has expired. Please log in again."),
        "users": MessageLookupByLibrary.simpleMessage("Users"),
        "usersDescription": MessageLookupByLibrary.simpleMessage(
            "Show and give or remove access from users"),
        "valid_email": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address"),
        "valid_phone_number": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid phone number"),
        "viewAndControlSystem":
            MessageLookupByLibrary.simpleMessage("View and Control System"),
        "viewComplaints":
            MessageLookupByLibrary.simpleMessage("View Complaints"),
        "visits": MessageLookupByLibrary.simpleMessage("Visits"),
        "wait_while_loading": MessageLookupByLibrary.simpleMessage(
            "Pleae wait while loading data"),
        "weak_password": MessageLookupByLibrary.simpleMessage(
            "The password entered is too weak. Use a stronger password with more characters."),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "welcome_message": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Smart Fire Alarm System. Please login or sign up."),
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "The password you entered is incorrect. Please try again.")
      };
}
