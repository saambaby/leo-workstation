import '../../features/onboarding/domain/onboarding_entities.dart';

/// Centralized context guards for public routes (`INV-CLIENT-ROUTE-GUARD-1`).
/// All enforced in [authRedirect] — route modules must not duplicate redirects.

bool hasVerifyEmailContext({
  VerifyEmailPendingContext? fromAuth,
  Object? extra,
  Map<String, String> queryParameters = const {},
}) {
  if (fromAuth != null) return true;
  if (extra is VerifyEmailPendingContext) return true;
  final email = queryParameters['email'];
  return email != null && email.isNotEmpty;
}

bool hasForgotPasswordVerifyContext(Object? extra) {
  return extra is String && extra.isNotEmpty;
}

bool hasResetPasswordContext(Object? extra) {
  return extra is String && extra.isNotEmpty;
}

bool hasSignupDetailsContext(Object? extra) {
  return extra is SignupDraft;
}

String? guardPublicRouteContext(
  String loc, {
  VerifyEmailPendingContext? emailVerificationPending,
  Object? extra,
  Map<String, String> queryParameters = const {},
}) {
  if (loc == '/verify-email' &&
      !hasVerifyEmailContext(
        fromAuth: emailVerificationPending,
        extra: extra,
        queryParameters: queryParameters,
      )) {
    return '/login';
  }
  if (loc == '/forgot-password/verify' && !hasForgotPasswordVerifyContext(extra)) {
    return '/forgot-password';
  }
  if (loc == '/reset-password' && !hasResetPasswordContext(extra)) {
    return '/forgot-password';
  }
  if (loc == '/signup/details' && !hasSignupDetailsContext(extra)) {
    return '/signup';
  }
  return null;
}
