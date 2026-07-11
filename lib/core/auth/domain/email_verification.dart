/// Signup path for native workstation onboarding (carried on verify context).
enum SignupPath {
  personal,
  customer,
}

/// Where the user entered the verify-email flow.
enum VerifyEmailSource {
  signup,
  login,
}

/// Router/auth metadata for the email-verify OTP screen (`INV-CLIENT-STATE-2`).
class VerifyEmailPendingContext {
  const VerifyEmailPendingContext({
    required this.email,
    this.source = VerifyEmailSource.signup,
    this.path = SignupPath.personal,
  });

  final String email;
  final VerifyEmailSource source;
  final SignupPath path;
}

/// Location string for redirect when [VerifyEmailPendingContext] is on auth state.
String verifyEmailLocation(VerifyEmailPendingContext ctx) {
  final source = ctx.source == VerifyEmailSource.login ? 'login' : 'signup';
  final path = ctx.path == SignupPath.customer ? 'customer' : 'personal';
  return '/verify-email?email=${Uri.encodeComponent(ctx.email)}&source=$source&path=$path';
}
