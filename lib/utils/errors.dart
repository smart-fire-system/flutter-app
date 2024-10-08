import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:flutter/widgets.dart';

class Errors {
  static String getFirebaseErrorMessage(BuildContext context, String code) {
    if (code.startsWith('Exception: ')) {
      code = code.replaceFirst('Exception: ', '');
    }
    switch (code) {
      case 'email-already-in-use':
        return S.of(context).email_already_in_use;
      case 'invalid-email':
        return S.of(context).invalid_email;
      case 'operation-not-allowed':
        return S.of(context).operation_not_allowed;
      case 'weak-password':
        return S.of(context).weak_password;
      case 'too-many-requests':
        return S.of(context).too_many_requests;
      case 'user-token-expired':
        return S.of(context).user_token_expired;
      case 'network-request-failed':
        return S.of(context).network_request_failed;
      case 'invalid-credential':
        return S.of(context).invalid_credential;
      case 'user-disabled':
        return S.of(context).user_disabled;
      case 'wrong-password':
        return S.of(context).wrong_password;
      case 'user-not-found':
        return S.of(context).user_not_found;
      case 'credential-already-in-use':
        return S.of(context).credential_already_in_use;
      case 'custom-token-mismatch':
        return S.of(context).custom_token_mismatch;
      case 'invalid-custom-token':
        return S.of(context).invalid_custom_token;
      case 'account-exists-with-different-credentials':
        return S.of(context).account_exists_with_different_credentials;
      case 'requires-recent-login':
        return S.of(context).requires_recent_login;
      case 'provider-already-linked':
        return S.of(context).provider_already_linked;
      case 'no-such-provider':
        return S.of(context).no_such_provider;
      case 'invalid-user-token':
        return S.of(context).invalid_user_token;
      case 'invalid-api-key':
        return S.of(context).invalid_api_key;
      case 'app-not-authorized':
        return S.of(context).app_not_authorized;
      case 'expired-action-code':
        return S.of(context).expired_action_code;
      case 'invalid-action-code':
        return S.of(context).invalid_action_code;
      case 'invalid-message-payload':
        return S.of(context).invalid_message_payload;
      case 'invalid-sender':
        return S.of(context).invalid_sender;
      case 'invalid-recipient-email':
        return S.of(context).invalid_recipient_email;
      case 'unauthorized-domain':
        return S.of(context).unauthorized_domain;
      case 'invalid-continue-uri':
        return S.of(context).invalid_continue_uri;
      case 'missing-continue-uri':
        return S.of(context).missing_continue_uri;
      case 'missing-email':
        return S.of(context).missing_email;
      case 'missing-phone-number':
        return S.of(context).missing_phone_number;
      case 'invalid-phone-number':
        return S.of(context).invalid_phone_number;
      case 'missing-verification-code':
        return S.of(context).missing_verification_code;
      case 'invalid-verification-code':
        return S.of(context).invalid_verification_code;
      case 'missing-verification-id':
        return S.of(context).missing_verification_id;
      case 'invalid-verification-id':
        return S.of(context).invalid_verification_id;
      case 'session-expired':
        return S.of(context).session_expired;
      case 'quota-exceeded':
        return S.of(context).quota_exceeded;
      case 'missing-app-credential':
        return S.of(context).missing_app_credential;
      case 'invalid-app-credential':
        return S.of(context).invalid_app_credential;
      case 'missing-client-identifier':
        return S.of(context).missing_client_identifier;
      case 'tenant-id-mismatch':
        return S.of(context).tenant_id_mismatch;
      case 'unsupported-tenant-operation':
        return S.of(context).unsupported_tenant_operation;
      case 'user-mismatch':
        return S.of(context).user_mismatch;
      case 'no-signed-in-user':
        return S.of(context).no_signed_in_user;
      case 'cancelled':
        return S.of(context).cancelled;

      case 'sign_in_failed':
        return S.of(context).sign_in_failed;
      case 'network_error':
        return S.of(context).network_request_failed;
      case 'sign_in_cancelled':
        return S.of(context).sign_in_cancelled;
      case 'sign_in_required':
        return S.of(context).sign_in_required;

      case 'invalid-argument':
        return S.of(context).invalid_argument;
      case 'deadline-exceeded':
        return S.of(context).deadline_exceeded;
      case 'not-found':
        return S.of(context).not_found;
      case 'already-exists':
        return S.of(context).already_exists;
      case 'permission-denied':
        return S.of(context).permission_denied;
      case 'resource-exhausted':
        return S.of(context).resource_exhausted;
      case 'failed-precondition':
        return S.of(context).failed_precondition;
      case 'aborted':
        return S.of(context).aborted;
      case 'out-of-range':
        return S.of(context).out_of_range;
      case 'unimplemented':
        return S.of(context).unimplemented;
      case 'internal':
        return S.of(context).internal;
      case 'unavailable':
        return S.of(context).unavailable;
      case 'data-loss':
        return S.of(context).data_loss;
      case 'unauthenticated':
        return S.of(context).unauthenticated;
      default:
        return S.of(context).unknown_error + '\n' + code;
    }
  }
}
