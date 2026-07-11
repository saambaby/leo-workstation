/// User-facing auth copy (INV-CLIENT-I18N-1 stepping stone until full intl ARB).
abstract final class AuthStrings {
  static const email = 'Email';
  static const password = 'Password';
  static const signIn = 'Sign in';
  static const signingIn = 'Signing in…';
  static const forgotPassword = 'Forgot password?';
  static const createAccount = 'Create an account';
  static const rememberDevice = 'Remember device';
  static const newToLeo = 'new to Leo?';

  // Screen subtitles (`.auth-sub`)
  static const loginSub = 'Sign in to your workstation';
  static const mfaSub = 'Two-factor verification';
  static const forgotSub = 'Reset your password';
  static const resetSub = 'Choose a new password';
  static const mfaEnrollSub = 'Set up two-factor authentication';
  static const inviteSub = "You've been invited";
  static const selectWorkspaceSub = 'Choose your workspace';

  // MFA
  static const mfaInfoNote =
      'Enter the 6-digit code from your authenticator app.';
  static const verifyAndContinue = 'Verify & continue';
  static const resend = 'Resend';
  static const mfaPrivilegedWarning =
      'Privileged roles (interpreter, dispatcher, admin) are prompted for ';
  static const mfaPrivilegedWarningBold = 'MFA';
  static const mfaPrivilegedWarningEnd = ' after password.';

  // MFA enroll
  static const mfaEnrollRoleWarnPrefix = 'Your role (';
  static const mfaEnrollRoleWarnSuffix =
      ') requires MFA. Finish enrollment to continue.';
  static const mfaEnrollStep1 = '1 · Scan with your authenticator';
  static const mfaEnrollStep1Hint = 'Google Authenticator, 1Password, Authy…';
  static const mfaEnrollManualKey = 'Or enter this key manually';
  static const mfaEnrollStep2 = '2 · Enter the 6-digit code to confirm';
  static const confirmEnrollment = 'Confirm & finish enrollment';
  static const mfaEnrollQrSemanticLabel =
      'Scannable QR code for authenticator app enrollment';
  static const mfaEnrollManualKeySemanticLabel =
      'Manual entry key for authenticator app enrollment';

  // Forgot password
  static const forgotInfoNote =
      "Enter your account email and we'll send a 6-digit reset code. The code expires in 30 minutes.";
  static const sendResetCode = 'Send reset code';
  static const backToSignIn = '← Back to sign in';
  static const forgotSuccessTitle =
      'If that email exists, a code is on its way';

  // Forgot password — verify code
  static const forgotVerifySub = 'Enter your reset code';
  static const forgotVerifyNotePrefix =
      'If that email exists, we sent a 6-digit code to ';
  static const forgotVerifyNoteSuffix =
      '. Enter it below to choose a new password.';
  static const forgotVerifyCodeLabel = 'Reset code';
  static const continueToNewPassword = 'Continue';
  static const resendCode = 'Resend code';
  static const resendingCode = 'Sending…';
  static const enterDifferentCode = '← Use a different code';

  // Reset password
  static const newPassword = 'New password';
  static const confirmNewPassword = 'Confirm new password';
  static const passwordPolicyHint =
      'Min 12 chars · 1 uppercase · 1 number · 1 symbol';
  static const passwordStrengthStrong = 'Strong · 14 chars · meets policy';
  static const setPasswordAndSignIn = 'Set password & sign in';
  static const passwordMismatch = 'Passwords do not match';
  static const resetSuccessLoginNote =
      'Password updated — sign in with your new password.';
  static const resetSessionWarn =
      'All other sessions will be signed out. Privileged roles re-enroll/confirm MFA on next sign-in.';

  // Invite
  static const yourName = 'Your name';
  static const setPassword = 'Set a password';
  static const namePlaceholder = 'Full name';
  static const passwordPlaceholder = 'Create a password';
  static const invitePasswordHint =
      'Min 12 chars · privileged role → MFA enrollment next';
  static const acceptAndJoin = 'Accept & join';
  static const inviteOrgName = 'Acme Language Services';
  static const inviteRoleLabel = 'invited you as ';
  static const inviteRoleName = 'Sub-Admin / Dispatcher';
  static const inviteRoleChip = 'sub_admin';
  static const inviteConsentTos = 'I agree to the Terms of Service';
  static const inviteConsentPrivacy = 'I agree to the Privacy Policy';
  static const inviteConsentBaaAck =
      'I acknowledge the Business Associate Agreement';

  static const signOut = 'Sign out';
  static const platformAdminUseWeb =
      'Platform admin accounts use Leo Web. Sign in at your organization\'s web dashboard instead.';
  static const blockedSurfaceTitle = 'Desktop or tablet required';
  static const blockedSurfaceSubtitle =
      'Customer sessions require a larger screen. Smartphone support arrives in v0.1.0.';
}
