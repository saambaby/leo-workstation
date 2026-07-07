import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_entities.freezed.dart';
part 'onboarding_entities.g.dart';

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

/// Where the user entered the verify-email pending screen.
enum VerifyEmailSource {
  signup,
  login,
}

/// Passed to `/verify-email` after signup or login with an unverified email.
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

@freezed
class SignupResult with _$SignupResult {
  const factory SignupResult({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'email_verification_required')
    @Default(true)
    bool emailVerificationRequired,
    @JsonKey(name: 'organization_id') String? organizationId,
    String? status,
  }) = _SignupResult;

  factory SignupResult.fromJson(Map<String, dynamic> json) =>
      _$SignupResultFromJson(json);
}

@freezed
class CatalogLanguage with _$CatalogLanguage {
  const factory CatalogLanguage({
    required String id,
    required String code,
    required String name,
    @JsonKey(name: 'is_signed') @Default(false) bool isSigned,
  }) = _CatalogLanguage;

  factory CatalogLanguage.fromJson(Map<String, dynamic> json) =>
      _$CatalogLanguageFromJson(json);
}

@freezed
class CatalogCertification with _$CatalogCertification {
  const factory CatalogCertification({
    required String id,
    required String name,
    @Default('') String issuer,
  }) = _CatalogCertification;

  factory CatalogCertification.fromJson(Map<String, dynamic> json) =>
      _$CatalogCertificationFromJson(json);
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
