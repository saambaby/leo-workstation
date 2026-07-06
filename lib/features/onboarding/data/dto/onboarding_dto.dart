import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/onboarding_entities.dart';

part 'onboarding_dto.freezed.dart';
part 'onboarding_dto.g.dart';

@freezed
class ConsentDto with _$ConsentDto {
  const factory ConsentDto({
    required bool tos,
    required bool privacy,
  }) = _ConsentDto;

  factory ConsentDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentDtoFromJson(json);
}

@freezed
class SignupPersonalRequestDto with _$SignupPersonalRequestDto {
  const factory SignupPersonalRequestDto({
    @JsonKey(name: 'account_type') @Default('personal') String accountType,
    required String email,
    required String password,
    required ConsentDto consent,
  }) = _SignupPersonalRequestDto;

  factory SignupPersonalRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignupPersonalRequestDtoFromJson(json);
}

@freezed
class SignupCustomerRequestDto with _$SignupCustomerRequestDto {
  const factory SignupCustomerRequestDto({
    @JsonKey(name: 'account_type') @Default('business') String accountType,
    @JsonKey(name: 'business_type') @Default('customer') String businessType,
    required String email,
    required String password,
    required String name,
    required String timezone,
    required ConsentDto consent,
  }) = _SignupCustomerRequestDto;

  factory SignupCustomerRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignupCustomerRequestDtoFromJson(json);
}

@freezed
class VerifyEmailRequestDto with _$VerifyEmailRequestDto {
  const factory VerifyEmailRequestDto({required String token}) =
      _VerifyEmailRequestDto;

  factory VerifyEmailRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailRequestDtoFromJson(json);
}

@freezed
class InterpreterCertDto with _$InterpreterCertDto {
  const factory InterpreterCertDto({
    @JsonKey(name: 'certification_id') required String certificationId,
    @JsonKey(name: 'cert_number', includeIfNull: false) String? certNumber,
    @JsonKey(name: 'expires_at', includeIfNull: false) String? expiresAt,
  }) = _InterpreterCertDto;

  factory InterpreterCertDto.fromJson(Map<String, dynamic> json) =>
      _$InterpreterCertDtoFromJson(json);

  factory InterpreterCertDto.fromEntry(InterpreterCertEntry entry) {
    return InterpreterCertDto(
      certificationId: entry.certificationId,
      certNumber: entry.certNumber,
      expiresAt: entry.expiresAt?.toIso8601String(),
    );
  }
}

@freezed
class InterpreterProfileRequestDto with _$InterpreterProfileRequestDto {
  const factory InterpreterProfileRequestDto({
    @JsonKey(name: 'display_name') required String displayName,
    required String timezone,
    @JsonKey(name: 'language_ids') required List<String> languageIds,
    required List<InterpreterCertDto> certifications,
  }) = _InterpreterProfileRequestDto;

  factory InterpreterProfileRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InterpreterProfileRequestDtoFromJson(json);

  factory InterpreterProfileRequestDto.fromInput(InterpreterProfileInput input) {
    return InterpreterProfileRequestDto(
      displayName: input.displayName,
      timezone: input.timezone,
      languageIds: input.languageIds,
      certifications: input.certifications
          .map(InterpreterCertDto.fromEntry)
          .toList(),
    );
  }
}

@freezed
class RegisteredAddressDto with _$RegisteredAddressDto {
  const factory RegisteredAddressDto({required String line1}) =
      _RegisteredAddressDto;

  factory RegisteredAddressDto.fromJson(Map<String, dynamic> json) =>
      _$RegisteredAddressDtoFromJson(json);
}

@freezed
class CustomerOrgRequestDto with _$CustomerOrgRequestDto {
  const factory CustomerOrgRequestDto({
    required String name,
    @JsonKey(name: 'industry_types') required List<String> industryTypes,
    @JsonKey(name: 'registered_address')
    required RegisteredAddressDto registeredAddress,
  }) = _CustomerOrgRequestDto;

  factory CustomerOrgRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerOrgRequestDtoFromJson(json);

  factory CustomerOrgRequestDto.fromInput(CustomerOrgInput input) {
    return CustomerOrgRequestDto(
      name: input.name,
      industryTypes: [input.industry],
      registeredAddress: RegisteredAddressDto(line1: input.registeredAddress),
    );
  }
}

@freezed
class TeamInviteRequestDto with _$TeamInviteRequestDto {
  const factory TeamInviteRequestDto({
    required String email,
    required String role,
  }) = _TeamInviteRequestDto;

  factory TeamInviteRequestDto.fromJson(Map<String, dynamic> json) =>
      _$TeamInviteRequestDtoFromJson(json);

  factory TeamInviteRequestDto.fromInput(TeamInviteInput input) {
    return TeamInviteRequestDto(email: input.email, role: input.role);
  }
}
