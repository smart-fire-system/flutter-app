// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Fire Alarm System';

  @override
  String get account_not_verified_title => 'Account Not Verified';

  @override
  String get account_not_verified_message =>
      'Your account is not verified. Please check your email for the verification link.';

  @override
  String get resend_verification_email => 'Resend Verification Email';

  @override
  String get access_denied_title => 'Access Denied';

  @override
  String get access_denied_message =>
      'You do not have access to this section. Please wait until the system administrators grant you access.';

  @override
  String get error => 'Error';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get and => 'and';

  @override
  String get forgot_password => 'Forgot your password?';

  @override
  String get enter_email_to_reset =>
      'Please enter your email address to reset your password.';

  @override
  String get reset_email_sent =>
      'A password reset email has been sent. Please check your inbox.';

  @override
  String get confirmEmailSent =>
      'A confirmation email has been sent. Please check your inbox.';

  @override
  String get searchBy => 'Search by name, email or phone number ...';

  @override
  String get searchByNameCode => 'Search by name or code ...';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get profile_subtitle => 'View and manage profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get system => 'System';

  @override
  String get settings => 'Settings';

  @override
  String get myProfile => 'Profile';

  @override
  String get viewAndControlSystem => 'View and Control System';

  @override
  String get manageAndConfigureSystem => 'Manage and Configure System';

  @override
  String get complaints => 'Complaints';

  @override
  String get complaints_subtitle => 'View and manage complaints';

  @override
  String get viewComplaints => 'View Complaints';

  @override
  String get submitComplaint => 'Submit Complaint';

  @override
  String get reports => 'Reports';

  @override
  String get visits => 'Visits';

  @override
  String get branches => 'Branches';

  @override
  String get companies => 'Companies';

  @override
  String get maintenanceContracts => 'Maintenance Contracts';

  @override
  String get systemStatusAndFaults => 'System Status and Faults';

  @override
  String get selectUsers => 'Seleect Users';

  @override
  String get allUsers => 'All Users';

  @override
  String get noUsersSelected => 'No users selected';

  @override
  String get users => 'Users';

  @override
  String get user => 'User';

  @override
  String get masterAdmins => 'Master Admins';

  @override
  String get admins => 'Admins';

  @override
  String get companyManagers => 'Company Managers';

  @override
  String get branchManagers => 'Branch Managers';

  @override
  String get employees => 'Employees';

  @override
  String get clients => 'Clients';

  @override
  String get noRoleUsers => 'No Role Users';

  @override
  String get masterAdmin => 'Master Admin';

  @override
  String get admin => 'Admin';

  @override
  String get companyManager => 'Company Manager';

  @override
  String get branchManager => 'Branch Manager';

  @override
  String get employee => 'Employee';

  @override
  String get client => 'Client';

  @override
  String get role => 'Role';

  @override
  String get chooseRole => 'Choose access role';

  @override
  String get noRole => 'No Role';

  @override
  String get logout => 'Logout';

  @override
  String get system_monitoring_control => 'System Monitoring and Control';

  @override
  String get system_monitoring_card_subtitle => 'View and manage system';

  @override
  String get system_monitoring_description =>
      'Monitor the current state of each sensor and control sub-units. You can also perform actions like turning devices on or off directly from this interface.';

  @override
  String get reportsDescription =>
      'Show reports for maintenance contracts, visits and system status.';

  @override
  String get complaintsDescription => 'Show open compaints or submit new one.';

  @override
  String get usersDescription => 'Show and give or remove access from users';

  @override
  String get branchesDescription => 'Add or remove branches';

  @override
  String get users_and_branches => 'Users & Branches';

  @override
  String get users_and_branches_subtitle => 'View and manage users & branches';

  @override
  String get users_branches_hierarchy_title => 'Users and Branches Hierarchy';

  @override
  String get users_branches_hierarchy_subtitle =>
      'View and manage users and branches hierarchy';

  @override
  String get branches_subtitle => 'View and manage branches';

  @override
  String get companies_subtitle => 'View and manage companies';

  @override
  String get users_subtitle => 'View and manage users';

  @override
  String get deleteUser => 'Remove User';

  @override
  String get changeAccessRole => 'Modify Access Role';

  @override
  String get confirmDeleteUser =>
      'Are you sure you want to permanently delete this user from the system?';

  @override
  String get confirmChangeAccessRole =>
      'Do you want to proceed with changing the user\'s access permissions?';

  @override
  String get userDeletedSuccessMessage =>
      'User has been successfully deleted from the system.';

  @override
  String get accessRoleChangedSuccessMessage =>
      'User\'s access role has been successfully updated.';

  @override
  String get companiesAndBranches => 'Companies and Branches';

  @override
  String get companiesAndBranchesDescription =>
      'Manage companies and their branches. Add or remove companies and branches, and view detailed information about them.';

  @override
  String get add => 'Add';

  @override
  String get addNewMasterAdmin => 'Add New Master Admin';

  @override
  String get addNewAdmin => 'Add New Admin';

  @override
  String get addNewCompanyManager => 'Add New Company Manager';

  @override
  String get addNewBranchManager => 'Add New Branch Manager';

  @override
  String get addNewEmployee => 'Add New Employee';

  @override
  String get addNewClient => 'Add New Client';

  @override
  String get noUsersToView => 'No users to view.';

  @override
  String get noCompaneiesToAddCompanyManager =>
      'There are no companies to add company managers to. Please add a company first.';

  @override
  String get noBranchesToAddBranchManager =>
      'There are no branches to add branch managers to. Please add a branch first.';

  @override
  String get noBranchesToAddEmployee =>
      'There are no branches to add employees to. Please add a branch first.';

  @override
  String get noBranchesToAddClient =>
      'There are no branches to add clients to. Please add a branch first.';

  @override
  String get not_authenticated =>
      'You are not logged in. To access this feature, please log in with your account.';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcome_message =>
      'Welcome to the Fire Alarm System. Please login or sign up.';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email Address';

  @override
  String get phone => 'Phone Number';

  @override
  String get password => 'Password';

  @override
  String get confirm_password => 'Please confirm your password';

  @override
  String get don_t_have_an_account => 'Don\'t have an account? Sign Up';

  @override
  String get already_have_an_account => 'Already have an account? Log In';

  @override
  String get select_language => 'Please choose a language';

  @override
  String get login_with_google => 'Log in with Google';

  @override
  String get login_with_facebook => 'Log in with Facebook';

  @override
  String get signup_with_google => 'Sign up with Google';

  @override
  String get signup_with_facebook => 'Sign up with Facebook';

  @override
  String get continue_with_google => 'Continue with Google';

  @override
  String get or => 'or';

  @override
  String get enter_name => 'Please enter your name';

  @override
  String get enter_phone_number => 'Please enter your phone number';

  @override
  String get valid_phone_number => 'Please enter a valid phone number';

  @override
  String get enter_password => 'Please enter your password';

  @override
  String get password_length => 'Password must be at least 6 characters long';

  @override
  String get password_mismatch => 'Passwords do not match';

  @override
  String get enter_email => 'Please enter your email address';

  @override
  String get valid_email => 'Please enter a valid email address';

  @override
  String get logging_in_progress => 'Please wait while logging you in';

  @override
  String get signup_in_progress => 'Please wait while creating your account';

  @override
  String get wait_while_loading => 'Pleae wait while loading data ...';

  @override
  String get login_welcome =>
      'Welcome back! Please log in to your account to continue.';

  @override
  String get signup_welcome =>
      'Welcome! Create a new account to join us and enjoy our services.';

  @override
  String get change_password => 'Change Password';

  @override
  String get edit_information => 'Edit Inforamation';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get info_updated => 'Profile info updated successfully';

  @override
  String get selectCompanies => 'Select companies to view';

  @override
  String get allCompanies => 'All companies';

  @override
  String get noCompaniesSelected => 'No companies selected';

  @override
  String get noBranchesToView => 'No branches to view';

  @override
  String get noCompaniesToView => 'No companies to view';

  @override
  String get noCompaniesToAddBranch =>
      'There are no companies to add branches to. Please add a company first';

  @override
  String get branchInformation => 'Branch Information';

  @override
  String get companyInformation => 'Company Information';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get address => 'Address';

  @override
  String get code => 'Code';

  @override
  String get createdAt => 'Created At';

  @override
  String get comment => 'Comment';

  @override
  String get addBranch => 'Add New Branch';

  @override
  String get branchModified =>
      'The branch details have been updated successfully.';

  @override
  String get branchAdded => 'The branch has been added successfully.';

  @override
  String get branchDeleted => 'The branch has been deleted successfully.';

  @override
  String get branchName => 'Branch Name';

  @override
  String get editBranch => 'Edit Branch';

  @override
  String get company => 'Company';

  @override
  String get branch => 'Branch';

  @override
  String get changeCompany => 'Change Company';

  @override
  String get deleteBranch => 'Delete Branch';

  @override
  String get branchModifyWarning =>
      'Please double-check the updated branch details before saving. Are you sure you want to proceed?';

  @override
  String get branchDeleteWarning =>
      'Deleting this branch is irreversible. Are you sure you want to proceed?';

  @override
  String get yesDeleteBranch => 'Yes, delete branch';

  @override
  String get yesSaveChanges => 'Yes, save changes';

  @override
  String get noCancel => 'No, cancel';

  @override
  String get waitDeltingBranch => 'Please wait while deleting branch';

  @override
  String get waitSavingBranch => 'Please wait while saving branch information';

  @override
  String get enterBranchName => 'Please enter the branch name';

  @override
  String get enterBranchAddress => 'Please enter the branch address';

  @override
  String get enterBranchPhone => 'Please enter the branch phone number';

  @override
  String get enterBranchEmail => 'Please enter the branch email address';

  @override
  String get enterBranchCompany => 'Please choose a company for this branch';

  @override
  String get addCompany => 'Add New Company';

  @override
  String get companyModified =>
      'The company details have been updated successfully.';

  @override
  String get companyAdded => 'The company has been added successfully.';

  @override
  String get companyDeleted => 'The company has been deleted successfully.';

  @override
  String get companyName => 'Company Name';

  @override
  String get editCompany => 'Edit Company';

  @override
  String get deleteCompany => 'Delete Company';

  @override
  String get companyModifyWarning =>
      'Please double-check the updated company details before saving. Are you sure you want to proceed?';

  @override
  String get companyDeleteWarning =>
      'Deleting this company is irreversible. Are you sure you want to proceed?';

  @override
  String get yesDeleteCompany => 'Yes, delete company';

  @override
  String get waitDeltingCompany => 'Please wait while deleting company';

  @override
  String get waitSavingCompany =>
      'Please wait while saving company information';

  @override
  String get enterCompanyName => 'Please enter the company name';

  @override
  String get enterCompanyAddress => 'Please enter the company address';

  @override
  String get enterCompanyPhone => 'Please enter the company phone number';

  @override
  String get enterCompanyEmail => 'Please enter the company email address';

  @override
  String get enterCompanyLogo => 'Please add a logo for the company';

  @override
  String get tabToAddLogo => 'Tab to add company logo';

  @override
  String get logo => 'Logo';

  @override
  String get companyLogo => 'Company Logo';

  @override
  String get errorPickingImage => 'An error occured while choosing the image';

  @override
  String get stepsToComplete =>
      'To continue using the application, please complete the following steps:';

  @override
  String get emailVerificationTitle => 'Email Verification';

  @override
  String get emailVerified => 'Your email has been successfully verified.';

  @override
  String get emailNotVerified =>
      'Your email is not verified. Click here to resend the verification email.';

  @override
  String get phoneNumberTitle => 'Add Phone Number';

  @override
  String get phoneNumberAdded => 'Your phone number has been added.';

  @override
  String get phoneNumberNotAdded =>
      'You have not added a phone number. Click here to add your phone number.';

  @override
  String get accessRoleTitle => 'Access Role';

  @override
  String get roleAssigned => 'You have been assigned an access role.';

  @override
  String get roleNotAssigned =>
      'You don\'t have an access role yet. Please wait for an administrator to grant you access.';

  @override
  String get tapToSelectUser => 'Tap to select a user';

  @override
  String get adminPermissions => 'Admin Permissions';

  @override
  String get canUpdateAdmins => 'Can update admins';

  @override
  String get canUpdateCompanyManagers => 'Can update company managers';

  @override
  String get canUpdateBranchManagers => 'Can update branch managers';

  @override
  String get canUpdateEmployees => 'Can update employees';

  @override
  String get canUpdateClients => 'Can update clients';

  @override
  String get canAddCompanies => 'Can add companies';

  @override
  String get canEditCompanies => 'Can edit companies';

  @override
  String get canDeleteCompanies => 'Can delete companies';

  @override
  String get canAddBranches => 'Can add branches';

  @override
  String get canEditBranches => 'Can edit branches';

  @override
  String get canDeleteBranches => 'Can delete branches';

  @override
  String get invalid_custom_token =>
      'The custom authentication token you provided is invalid. Please check and try again.';

  @override
  String get custom_token_mismatch =>
      'The custom token provided does not match the expected format. Ensure it is correct.';

  @override
  String get invalid_email =>
      'The email address entered is not valid. Please provide a valid email address.';

  @override
  String get invalid_credential =>
      'The credentials you provided are not recognized. Please check your login details.';

  @override
  String get user_disabled =>
      'This account has been disabled by the administrator. Contact support for assistance.';

  @override
  String get email_already_in_use =>
      'An account already exists with this email address. Please login or use a different email.';

  @override
  String get wrong_password =>
      'The password you entered is incorrect. Please try again.';

  @override
  String get too_many_requests =>
      'Too many requests. Please wait for a while before trying again.';

  @override
  String get account_exists_with_different_credentials =>
      'An account with this email exists but with different credentials. Try logging in with a different method.';

  @override
  String get requires_recent_login =>
      'For security purposes, please log in again to continue.';

  @override
  String get provider_already_linked =>
      'This account is already linked to another authentication provider.';

  @override
  String get no_such_provider =>
      'The provider you are trying to use is not available for this account.';

  @override
  String get invalid_user_token =>
      'The user token is invalid. Please log in again.';

  @override
  String get user_token_expired =>
      'The session has expired. Please log in again.';

  @override
  String get user_not_found =>
      'No user was found with this information. Please check your details.';

  @override
  String get invalid_api_key =>
      'The API key used is invalid. Contact support if the issue persists.';

  @override
  String get credential_already_in_use =>
      'This credential is already in use with another account. Try a different login method.';

  @override
  String get operation_not_allowed =>
      'This operation is not allowed. Contact the administrator for more information.';

  @override
  String get weak_password =>
      'The password entered is too weak. Use a stronger password with more characters.';

  @override
  String get app_not_authorized =>
      'This app is not authorized to access the Firebase project. Contact the administrator.';

  @override
  String get expired_action_code =>
      'This action code has expired. Request a new one to proceed.';

  @override
  String get invalid_action_code =>
      'The action code provided is invalid or has already been used.';

  @override
  String get invalid_message_payload =>
      'The message payload is invalid. Please contact support.';

  @override
  String get invalid_sender =>
      'The sender is not authorized. Please ensure you are using a valid email.';

  @override
  String get invalid_recipient_email =>
      'The recipient email address is invalid. Please check and try again.';

  @override
  String get unauthorized_domain =>
      'The domain you are trying to use is not authorized. Contact support for further details.';

  @override
  String get invalid_continue_uri => 'The continue URL provided is invalid.';

  @override
  String get missing_continue_uri =>
      'A continue URL is required but missing. Please provide one.';

  @override
  String get missing_email =>
      'The email field is required. Please provide an email address.';

  @override
  String get missing_phone_number =>
      'The phone number field is required. Please provide a phone number.';

  @override
  String get invalid_phone_number =>
      'The phone number entered is invalid. Please provide a valid phone number.';

  @override
  String get missing_verification_code =>
      'The verification code is missing. Please enter the code sent to you.';

  @override
  String get invalid_verification_code =>
      'The verification code entered is invalid. Please try again.';

  @override
  String get missing_verification_id =>
      'The verification ID is missing. Please try the process again.';

  @override
  String get invalid_verification_id =>
      'The verification ID entered is invalid. Please try again.';

  @override
  String get session_expired => 'The session has expired. Please log in again.';

  @override
  String get quota_exceeded =>
      'The quota for this operation has been exceeded. Try again later.';

  @override
  String get missing_app_credential =>
      'The app credential is missing. Please try again.';

  @override
  String get invalid_app_credential => 'The app credential entered is invalid.';

  @override
  String get missing_client_identifier => 'The client identifier is missing.';

  @override
  String get tenant_id_mismatch =>
      'The tenant ID does not match the expected value.';

  @override
  String get unsupported_tenant_operation =>
      'This operation is not supported for this tenant.';

  @override
  String get user_mismatch =>
      'The logged-in user does not match the expected user.';

  @override
  String get network_request_failed =>
      'A network error occurred. Please check your connection and try again.';

  @override
  String get no_signed_in_user =>
      'No user is signed in. Please log in to continue.';

  @override
  String get cancelled => 'The operation was cancelled. Please try again.';

  @override
  String get unknown_error =>
      'An unknown error occurred. Please try again later.';

  @override
  String get invalid_argument =>
      'An invalid argument was provided. Please check your input.';

  @override
  String get deadline_exceeded =>
      'The operation took too long to complete. Please try again later.';

  @override
  String get not_found => 'The requested resource was not found.';

  @override
  String get already_exists => 'The resource already exists.';

  @override
  String get permission_denied =>
      'You do not have permission to perform this action.';

  @override
  String get resource_exhausted =>
      'Resource limit exceeded. Please try again later.';

  @override
  String get failed_precondition =>
      'The operation cannot be performed due to failed precondition.';

  @override
  String get aborted => 'The operation was aborted due to a conflict.';

  @override
  String get out_of_range =>
      'The provided value is out of the acceptable range.';

  @override
  String get unimplemented => 'This operation is not implemented or supported.';

  @override
  String get internal => 'An internal error occurred. Please try again later.';

  @override
  String get unavailable =>
      'The service is currently unavailable. Please check your connection or try again later.';

  @override
  String get data_loss => 'Data loss occurred. Please try again later.';

  @override
  String get unauthenticated => 'You need to sign in to perform this action.';

  @override
  String get sign_in_failed =>
      'The sign-in attempt has failed. Please try again later or contact support if the issue persists.';

  @override
  String get network_error =>
      'A network error occurred during sign-in. Please check your internet connection and try again.';

  @override
  String get sign_in_cancelled =>
      'The sign-in process was cancelled. Please try again if you want to continue.';

  @override
  String get sign_in_required =>
      'You need to sign in to proceed. Please sign in and try again.';

  @override
  String get contract_wait_employee_sign_subtitle =>
      'You must sign first to activate the contract.';

  @override
  String get contract_wait_other_client_sign_title =>
      'Waiting for client signature';

  @override
  String get contract_wait_other_client_sign_subtitle =>
      'Waiting for the client signature to activate the contract.';

  @override
  String get contract_active_title => 'Contract Active';

  @override
  String contract_active_until(Object date) {
    return 'Active until $date';
  }

  @override
  String get contract_expired_title => 'Contract Expired';

  @override
  String contract_expired_since(Object date) {
    return 'Expired on $date';
  }

  @override
  String get snackbar_signing_not_enabled => 'Signing is not enabled yet';

  @override
  String get snackbar_client_notification_not_enabled =>
      'Client notification is not enabled yet';

  @override
  String get signature_employee_title => 'Employee Signature';

  @override
  String get signature_client_title => 'Client Signature';

  @override
  String signature_confirm_dialog_title(Object title) {
    return 'Confirm $title';
  }

  @override
  String get signature_confirm_dialog_body =>
      'By confirming, your signature will be recorded on this contract. This action cannot be undone.';

  @override
  String get slide_to_confirm => 'Slide to confirm';

  @override
  String get linear_stage_draft => 'Draft';

  @override
  String get linear_stage_employee_signed => 'Employee Signed';

  @override
  String get linear_stage_client_signed => 'Client Signed';

  @override
  String get linear_stage_active => 'Active';

  @override
  String get linear_stage_expired => 'Expired';

  @override
  String contract_number_prefix(Object number) {
    return 'Contract No: $number';
  }

  @override
  String get contract_label => 'Contract';

  @override
  String get period_from => 'Active from ';

  @override
  String get period_to => ' to ';

  @override
  String get employee_label => 'Employee: ';

  @override
  String get client_label => 'Client: ';

  @override
  String get branch_label => 'Branch: ';

  @override
  String get sign_employee_required_title => 'Employee signature required';

  @override
  String get sign_employee_required_subtitle =>
      'You must sign first so the client can sign.';

  @override
  String get waiting_employee_signature_title =>
      'Waiting for employee signature';

  @override
  String get waiting_employee_signature_subtitle =>
      'Waiting for the employee signature so the client can sign.';

  @override
  String get sign_client_required_title => 'Client signature required';

  @override
  String get view_contract => 'View Contract';

  @override
  String get view_contract_subtitle =>
      'View contract details and export to PDF';

  @override
  String get new_visit_report => 'Add Visit Report';

  @override
  String get new_visit_report_subtitle => 'Add new visit report';

  @override
  String get new_contract => 'Add Contract';

  @override
  String get new_new_contract_subtitle => 'Add new contract';

  @override
  String get visit_reports => 'Visit Reports';

  @override
  String get visit_reports_subtitle => 'View visit details and export to PDF';

  @override
  String get emergency_visit_request => 'Request Emergency Visit';

  @override
  String get emergency_visit_request_subtitle => 'Request emergency visit';

  @override
  String get contracts => 'Contracts';

  @override
  String get no_contracts_yet => 'There are no contracts yet!';

  @override
  String get reports_contracts_title => 'Reports & Contracts';

  @override
  String get reports_contracts_card_title => 'Contracts & Reports';

  @override
  String get reports_contracts_card_subtitle =>
      'View and manage contracts and visit reports, submit emergency requests or complaints.';

  @override
  String get reports_contracts_subtitle =>
      'View and manage reports & contracts';

  @override
  String get contract_components => 'Contract Components';

  @override
  String get contract_components_subtitle => 'Update contract components';

  @override
  String get offline_mode => 'Offline Mode';

  @override
  String get offline_mode_subtitle => 'View and manage system in offline mode';

  @override
  String get share_contract => 'Share Contract';

  @override
  String get share_contract_subtitle =>
      'Share contract with other employees or clients';

  @override
  String get share_with => 'Share with';

  @override
  String get no_users => 'No users';

  @override
  String get contract_sharing_updated_success =>
      'Contract sharing updated successfully.';

  @override
  String get contract_signed_success => 'Contract signed successfully.';

  @override
  String get emergency_visits => 'Emergency Visits';

  @override
  String get emergency_visits_subtitle =>
      'View emergency visits or request a new one';

  @override
  String get feature_not_supported_yet => 'Feature not supported yet';

  @override
  String get suitable => 'Suitable';

  @override
  String get unsuitable => 'Unsuitable';

  @override
  String system_report_no(Object number) {
    return 'System Report No. $number';
  }

  @override
  String emergency_visit_request_no(Object number) {
    return 'Request No. $number';
  }

  @override
  String get visit_date => 'Visit Date: ';

  @override
  String get system_status => 'System Status: ';

  @override
  String get signed => 'Signed';

  @override
  String get not_signed => 'Not Signed';

  @override
  String get visit_report_signed_success => 'Visit report signed successfully.';

  @override
  String get notifications_subtitle => 'View notifications';

  @override
  String get view_visit_report => 'View Visit Report';

  @override
  String get signature_confirm_dialog_body_visit_report =>
      'By confirming, your signature will be recorded on this visit report. This action cannot be undone.';

  @override
  String get visit_report_wait_client_sign_subtitle =>
      'Please sign the visit report to proceed.';

  @override
  String get visit_report_wait_other_client_sign_subtitle =>
      'Waiting for the client signature to complete the visit report.';

  @override
  String get firstPartyInformation => 'First Party Information';

  @override
  String get firstPartyName => 'First Party Name';

  @override
  String get firstPartyRepresentativeName => 'First Party Representative Name';

  @override
  String get firstPartyAddress => 'First Party Address';

  @override
  String get firstPartyCommercialRecord => 'First Party Commercial Record';

  @override
  String get firstPartyG => 'First Party G';

  @override
  String get firstPartyIdNumber => 'First Party ID Number';

  @override
  String get firstPartySignature => 'First Party Signature';

  @override
  String get tapToUploadSignature => 'Tap to upload signature';

  @override
  String get actions => 'Actions';

  @override
  String get representativeName => 'Representative Name';

  @override
  String get commercialRecord => 'Commercial Record';

  @override
  String get g => 'G';

  @override
  String get idNumber => 'ID Number';

  @override
  String get signature => 'Signature';

  @override
  String get noSignatureAddedYet => 'No signature added yet';

  @override
  String get signatures_title => 'Signature validation';

  @override
  String get signatures_id_label => 'Signature ID';

  @override
  String get signatures_id_hint => 'Example: CE-01012026-123-45-6';

  @override
  String get signatures_scan_qr_tooltip => 'Scan QR';

  @override
  String get signatures_validate_button => 'Validate';

  @override
  String get signatures_clear_button => 'Clear';

  @override
  String get signatures_empty_error => 'Please enter a signature ID.';

  @override
  String get signatures_invalid_error => 'Invalid signature.';

  @override
  String get signatures_enter_or_scan_hint =>
      'Enter a signature ID or scan a QR code to validate.';

  @override
  String get signatures_scan_title => 'Scan QR';

  @override
  String get signatures_point_camera_hint => 'Point the camera at the QR code.';

  @override
  String get signatures_toggle_flash_tooltip => 'Toggle flash';

  @override
  String get signatures_section_signature_summary => 'Signature summary';

  @override
  String get signatures_section_user_summary => 'User summary';

  @override
  String get signatures_section_contract_summary => 'Contract summary';

  @override
  String get signatures_section_visit_report_summary => 'Visit report summary';

  @override
  String get signatures_section_report_summary => 'Report summary';

  @override
  String get signatures_field_signature_id => 'Signature ID';

  @override
  String get signatures_field_signature_code => 'Signature code';

  @override
  String get signatures_field_signed_at => 'Signed at';

  @override
  String get signatures_field_type => 'Type';

  @override
  String get signatures_type_contract => 'Contract';

  @override
  String get signatures_type_visit_report => 'Visit report';

  @override
  String get signatures_type_unknown => '-';

  @override
  String get signatures_field_role => 'Role';

  @override
  String get signatures_role_client => 'Client';

  @override
  String get signatures_role_employee => 'Employee';

  @override
  String get signatures_role_unknown => '-';

  @override
  String get signatures_field_name => 'Name';

  @override
  String get signatures_field_user_code => 'User code';

  @override
  String get signatures_field_email => 'Email';

  @override
  String get signatures_field_phone => 'Phone';

  @override
  String get signatures_field_contract_code => 'Contract code';

  @override
  String get signatures_field_contract_state => 'Contract state';

  @override
  String get signatures_field_contract_number => 'Contract number';

  @override
  String get signatures_field_client => 'Client';

  @override
  String get signatures_field_employee => 'Employee';

  @override
  String get signatures_field_visit_report_code => 'Visit report code';

  @override
  String get signatures_field_visit_date => 'Visit date';

  @override
  String get signatures_field_contract_id => 'Contract ID';

  @override
  String get signatures_field_visit_report_id => 'Visit report ID';

  @override
  String get time_now_long => 'just now';

  @override
  String get time_now_short => 'now';

  @override
  String time_min_long(int n) {
    return '$n min ago';
  }

  @override
  String time_min_short(int n) {
    return '${n}m';
  }

  @override
  String time_hour_long(int n) {
    return '$n hour ago';
  }

  @override
  String time_hour_short(int n) {
    return '${n}h';
  }

  @override
  String time_day_long(int n) {
    return '$n day ago';
  }

  @override
  String time_day_short(int n) {
    return '${n}d';
  }

  @override
  String time_week_long(int n) {
    return '$n week ago';
  }

  @override
  String time_week_short(int n) {
    return '${n}w';
  }

  @override
  String time_month_long(int n) {
    return '$n month ago';
  }

  @override
  String time_month_short(int n) {
    return '${n}mo';
  }

  @override
  String time_year_long(int n) {
    return '$n year ago';
  }

  @override
  String time_year_short(int n) {
    return '${n}y';
  }

  @override
  String get status_created => 'Request created';

  @override
  String get status_pending => 'Awaiting confirmation';

  @override
  String get status_approved => 'Visit approved';

  @override
  String get status_rejected => 'Visit rejected';

  @override
  String get status_canceled => 'Request canceled';

  @override
  String get status_completed => 'Request completed';

  @override
  String get emergency_visit_not_found => 'Not found';

  @override
  String emergency_visit_request_number(String code) {
    return 'Request #$code';
  }

  @override
  String get emergency_visit_requested_by_label => 'Requested by';

  @override
  String get emergency_visit_description_label => 'Description';

  @override
  String get emergency_visit_comments_title => 'Comments';

  @override
  String emergency_visit_requested_sentence(String userName, String dateText) {
    return '$userName requested an emergency visit on $dateText';
  }

  @override
  String get emergency_visit_created_at_prefix => 'Created at: ';

  @override
  String get emergency_visit_requested_by_prefix => 'Requested by: ';

  @override
  String get emergency_visit_last_updated_prefix => 'Last updated: ';

  @override
  String get emergency_visit_no_updates_yet => 'No updates yet';

  @override
  String get emergency_visit_no_comments_yet => 'No comments yet';

  @override
  String get emergency_visit_write_comment_hint => 'Write a comment...';

  @override
  String get emergency_visit_change_status_title => 'Change status';

  @override
  String get emergency_visit_change_status_button => 'Change status';

  @override
  String get emergency_visit_current_label => 'Current:';

  @override
  String get emergency_visit_new_status_label => 'New status';

  @override
  String get emergency_visit_save => 'Save';

  @override
  String get sort_old_to_new => 'Old → New';

  @override
  String get sort_new_to_old => 'New → Old';

  @override
  String emergency_visit_status_changed_message(
      String dateText, String userName, String status) {
    return '$dateText\n$userName changed status to ($status)';
  }
}
