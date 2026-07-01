/// Signup path for native workstation onboarding.
enum SignupPath {
  personal,
  customer,
}

/// Context passed between signup screens via go_router [extra].
class SignupDraft {
  const SignupDraft({
    required this.path,
    this.orgName,
    this.timezone = 'America/New_York',
  });

  final SignupPath path;
  final String? orgName;
  final String timezone;
}

/// Passed to verify-email after successful signup.
class SignupVerifyContext {
  const SignupVerifyContext({
    required this.email,
    required this.path,
  });

  final String email;
  final SignupPath path;
}

class SignupResult {
  const SignupResult({
    required this.userId,
    required this.emailVerificationRequired,
    this.organizationId,
    this.status,
  });

  final String userId;
  final bool emailVerificationRequired;
  final String? organizationId;
  final String? status;
}

class CatalogLanguage {
  const CatalogLanguage({
    required this.id,
    required this.code,
    required this.name,
    this.isSigned = false,
  });

  final String id;
  final String code;
  final String name;
  final bool isSigned;
}

class CatalogCertification {
  const CatalogCertification({
    required this.id,
    required this.name,
    required this.issuer,
  });

  final String id;
  final String name;
  final String issuer;
}

class InterpreterCertEntry {
  const InterpreterCertEntry({
    required this.certificationId,
    required this.name,
    this.certNumber,
    this.expiresAt,
    this.proofUploaded = false,
  });

  final String certificationId;
  final String name;
  final String? certNumber;
  final DateTime? expiresAt;
  final bool proofUploaded;
}

class InterpreterProfileInput {
  const InterpreterProfileInput({
    required this.displayName,
    required this.timezone,
    required this.languageIds,
    required this.certifications,
  });

  final String displayName;
  final String timezone;
  final List<String> languageIds;
  final List<InterpreterCertEntry> certifications;
}

class CustomerOrgInput {
  const CustomerOrgInput({
    required this.name,
    required this.industry,
    required this.registeredAddress,
  });

  final String name;
  final String industry;
  final String registeredAddress;
}

class TeamInviteInput {
  const TeamInviteInput({
    required this.email,
    required this.role,
  });

  final String email;
  final String role;
}
