import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

/// Signup / invite consent payload (`tos`, `privacy`, optional `baa_ack`).
@freezed
class ConsentDto with _$ConsentDto {
  const factory ConsentDto({
    required bool tos,
    required bool privacy,
    @JsonKey(name: 'baa_ack', includeIfNull: false) bool? baaAck,
  }) = _ConsentDto;

  factory ConsentDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentDtoFromJson(json);
}

@freezed
class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({
    required String email,
    required String password,
    @JsonKey(name: 'totp_code', includeIfNull: false) String? totpCode,
  }) = _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);
}

@freezed
class MfaEnrollRequestDto with _$MfaEnrollRequestDto {
  const factory MfaEnrollRequestDto({
    @JsonKey(name: 'enrollment_token') required String enrollmentToken,
    @JsonKey(name: 'totp_code') required String totpCode,
  }) = _MfaEnrollRequestDto;

  factory MfaEnrollRequestDto.fromJson(Map<String, dynamic> json) =>
      _$MfaEnrollRequestDtoFromJson(json);
}

@freezed
class RefreshTokenRequestDto with _$RefreshTokenRequestDto {
  const factory RefreshTokenRequestDto({
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _RefreshTokenRequestDto;

  factory RefreshTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestDtoFromJson(json);
}

@freezed
class ForgotPasswordRequestDto with _$ForgotPasswordRequestDto {
  const factory ForgotPasswordRequestDto({required String email}) =
      _ForgotPasswordRequestDto;

  factory ForgotPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestDtoFromJson(json);
}

@freezed
class ResetPasswordRequestDto with _$ResetPasswordRequestDto {
  const factory ResetPasswordRequestDto({
    required String token,
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _ResetPasswordRequestDto;

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);
}

@freezed
class InviteAcceptRequestDto with _$InviteAcceptRequestDto {
  const factory InviteAcceptRequestDto({
    required String token,
    required String password,
    required ConsentDto consent,
  }) = _InviteAcceptRequestDto;

  factory InviteAcceptRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InviteAcceptRequestDtoFromJson(json);
}
