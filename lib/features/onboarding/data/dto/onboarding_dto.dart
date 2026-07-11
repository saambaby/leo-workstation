import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/onboarding_entities.dart';

part 'onboarding_dto.freezed.dart';
part 'onboarding_dto.g.dart';

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
