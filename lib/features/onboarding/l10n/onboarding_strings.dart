/// Onboarding + signup copy.
abstract final class OnboardingStrings {
  static const signupSub = 'Create an account · one signup, three paths';
  static const stepAccountType = 'Account type';
  static const stepDetails = 'Details';
  static const stepVerifyEmail = 'Verify email';
  static const whatDescribesYou = 'What describes you?';
  static const personalTitle = 'Personal';
  static const personalSubtitle = 'Interpreter / individual';
  static const businessTitle = 'Business';
  static const businessSubtitle = 'Organization';
  static const businessSubTypeLabel = 'Business sub-type';
  static const businessSubTypeHint = '(if Business)';
  static const customerTitle = 'Customer';
  static const customerSubtitle = 'type=customer · books interpreters';
  static const lspTitle = 'LSP';
  static const lspSubtitle = 'type=lsp · provides interpreters';
  static const lspExternalNote =
      'LSP signup and onboarding run in Leo Web — opens in your browser.';
  static const lspUrlUnset = 'Web signup URL is not configured for this build.';
  static const resultingPath = 'RESULTING ONBOARDING PATH →';
  static const pathPersonal = 'Personal → interpreter profile';
  static const pathCustomer = 'Customer → org + members';
  static const pathLsp = 'LSP → languages + pricing (web)';
  static const backToSignIn = '← Back to sign in';
  static const continueLabel = 'Continue →';

  static const detailsSubPersonal = 'Create your interpreter account';
  static const detailsSubCustomer = 'Create your customer organization';
  static const orgName = 'Organization name';
  static const timezone = 'Timezone';
  static const email = 'Email';
  static const password = 'Password';
  static const confirmPassword = 'Confirm password';
  static const acceptTos = 'I accept the Terms of Service';
  static const acceptPrivacy = 'I accept the Privacy Policy';
  static const createAccount = 'Create account';
  static const passwordMismatch = 'Passwords do not match';
  static const consentRequired = 'You must accept the terms to continue';
  static const duplicateEmail = 'An account with this email already exists';

  static const verifySub = 'Verify your email';
  static const verifyLoginSub =
      'Sign in after you verify the link we emailed you';
  static const verifyPendingTitle = 'Check your email';
  static const verifyLinkSentPrefix = 'We sent a verification link to ';
  static const verifyLinkSentSuffix =
      '. Open it in your browser to verify your account.';
  static const verifyPendingBody =
      'After verifying, return here and sign in with your password.';
  static const verifyLinkExpires = 'The link expires in 24 hours.';
  static const openEmailApp = 'Open email app';
  static const goToSignIn = 'Go to sign in';
  static const wrongEmailSignup =
      'Wrong email? Sign up again (duplicate emails return an error)';
  static const verifiedLoginNote =
      'Email verified — sign in with your new password.';

  static const personalWelcome = 'Set up your interpreter profile';
  static const personalChip = 'Personal · interpreter';
  static const stepProfile = 'Profile & languages';
  static const stepAffiliate = 'Affiliate';
  static const displayName = 'Display name';
  static const languagesLabel = 'Languages you interpret';
  static const certificationsLabel = 'Certifications';
  static const certificationsHint =
      '(picked from global catalog; LSP verifies later)';
  static const uploadProof = 'Upload proof';
  static const addCert = '+ add';
  static const affiliationNote =
      'You interpret through an LSP. Next, request an affiliation — an LSP must approve you before you receive requests.';
  static const nextAffiliate = 'Next: affiliate with an LSP →';
  static const affiliationIdleNote =
      'Request an affiliation with an LSP to start receiving interpretation requests.';

  static const customerWelcome = 'Set up your organization';
  static const customerChip = 'Business · customer';
  static const stepOrgProfile = 'Org profile';
  static const stepInviteTeam = 'Invite team';
  static const stepDone = 'Done';
  static const industry = 'Industry';
  static const registeredAddress = 'Registered address';
  static const registeredAddressHint = '(default on-site address)';
  static const inviteTeam = 'Invite your team';
  static const inviteTeamHint = '(customer users)';
  static const customerUserRole = 'Customer User';
  static const customerAdminRole = 'Customer Admin';
  static const addInviteRow = '+ Row';
  static const customerPortalNote =
      "You'll configure required billing-popup fields and LSP links in your web portal after setup.";
  static const finishAndCall = 'Finish & place first call →';

  static const industries = ['Healthcare', 'Education', 'Legal', 'Other'];
  static const timezones = [
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'America/Phoenix',
    'Europe/London',
    'UTC',
  ];
}
