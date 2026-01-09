import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

class Errors {
  static String getFirebaseErrorMessage(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context)!;
    if (code.startsWith('Exception: ')) {
      code = code.replaceFirst('Exception: ', '');
    }
    switch (code) {
      case 'email-already-in-use':
        return l10n.email_already_in_use;
      case 'invalid-email':
        return l10n.invalid_email;
      case 'operation-not-allowed':
        return l10n.operation_not_allowed;
      case 'weak-password':
        return l10n.weak_password;
      case 'too-many-requests':
        return l10n.too_many_requests;
      case 'user-token-expired':
        return l10n.user_token_expired;
      case 'network-request-failed':
        return l10n.network_request_failed;
      case 'invalid-credential':
        return l10n.invalid_credential;
      case 'user-disabled':
        return l10n.user_disabled;
      case 'wrong-password':
        return l10n.wrong_password;
      case 'user-not-found':
        return l10n.user_not_found;
      case 'credential-already-in-use':
        return l10n.credential_already_in_use;
      case 'custom-token-mismatch':
        return l10n.custom_token_mismatch;
      case 'invalid-custom-token':
        return l10n.invalid_custom_token;
      case 'account-exists-with-different-credentials':
        return l10n.account_exists_with_different_credentials;
      case 'requires-recent-login':
        return l10n.requires_recent_login;
      case 'provider-already-linked':
        return l10n.provider_already_linked;
      case 'no-such-provider':
        return l10n.no_such_provider;
      case 'invalid-user-token':
        return l10n.invalid_user_token;
      case 'invalid-api-key':
        return l10n.invalid_api_key;
      case 'app-not-authorized':
        return l10n.app_not_authorized;
      case 'expired-action-code':
        return l10n.expired_action_code;
      case 'invalid-action-code':
        return l10n.invalid_action_code;
      case 'invalid-message-payload':
        return l10n.invalid_message_payload;
      case 'invalid-sender':
        return l10n.invalid_sender;
      case 'invalid-recipient-email':
        return l10n.invalid_recipient_email;
      case 'unauthorized-domain':
        return l10n.unauthorized_domain;
      case 'invalid-continue-uri':
        return l10n.invalid_continue_uri;
      case 'missing-continue-uri':
        return l10n.missing_continue_uri;
      case 'missing-email':
        return l10n.missing_email;
      case 'missing-phone-number':
        return l10n.missing_phone_number;
      case 'invalid-phone-number':
        return l10n.invalid_phone_number;
      case 'missing-verification-code':
        return l10n.missing_verification_code;
      case 'invalid-verification-code':
        return l10n.invalid_verification_code;
      case 'missing-verification-id':
        return l10n.missing_verification_id;
      case 'invalid-verification-id':
        return l10n.invalid_verification_id;
      case 'session-expired':
        return l10n.session_expired;
      case 'quota-exceeded':
        return l10n.quota_exceeded;
      case 'missing-app-credential':
        return l10n.missing_app_credential;
      case 'invalid-app-credential':
        return l10n.invalid_app_credential;
      case 'missing-client-identifier':
        return l10n.missing_client_identifier;
      case 'tenant-id-mismatch':
        return l10n.tenant_id_mismatch;
      case 'unsupported-tenant-operation':
        return l10n.unsupported_tenant_operation;
      case 'user-mismatch':
        return l10n.user_mismatch;
      case 'no-signed-in-user':
        return l10n.no_signed_in_user;
      case 'cancelled':
        return l10n.cancelled;

      case 'sign_in_failed':
        return l10n.sign_in_failed;
      case 'network_error':
        return l10n.network_request_failed;
      case 'sign_in_cancelled':
        return l10n.sign_in_cancelled;
      case 'sign_in_required':
        return l10n.sign_in_required;

      case 'invalid-argument':
        return l10n.invalid_argument;
      case 'deadline-exceeded':
        return l10n.deadline_exceeded;
      case 'not-found':
        return l10n.not_found;
      case 'already-exists':
        return l10n.already_exists;
      case 'permission-denied':
        return l10n.permission_denied;
      case 'resource-exhausted':
        return l10n.resource_exhausted;
      case 'failed-precondition':
        return l10n.failed_precondition;
      case 'aborted':
        return l10n.aborted;
      case 'out-of-range':
        return l10n.out_of_range;
      case 'unimplemented':
        return l10n.unimplemented;
      case 'internal':
        return l10n.internal;
      case 'unavailable':
        return l10n.unavailable;
      case 'data-loss':
        return l10n.data_loss;
      case 'popup_closed':
        return l10n.cancelled;
      case 'unauthenticated':
        return l10n.unauthenticated;
      default:
        return '${l10n.unknown_error}\n$code';
    }
  }
}
