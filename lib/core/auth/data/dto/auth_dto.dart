import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

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
class VerifyEmailRequestDto with _$VerifyEmailRequestDto {
  const factory VerifyEmailRequestDto({
    required String email,
    required String code,
  }) = _VerifyEmailRequestDto;

  factory VerifyEmailRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailRequestDtoFromJson(json);
}

@freezed
class ResendVerifyEmailRequestDto with _$ResendVerifyEmailRequestDto {
  const factory ResendVerifyEmailRequestDto({required String email}) =
      _ResendVerifyEmailRequestDto;

  factory ResendVerifyEmailRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResendVerifyEmailRequestDtoFromJson(json);
}

@freezed
class ResetPasswordVerifyRequestDto with _$ResetPasswordVerifyRequestDto {
  const factory ResetPasswordVerifyRequestDto({
    required String email,
    required String code,
  }) = _ResetPasswordVerifyRequestDto;

  factory ResetPasswordVerifyRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordVerifyRequestDtoFromJson(json);
}

@freezed
class ResetPasswordRequestDto with _$ResetPasswordRequestDto {
  const factory ResetPasswordRequestDto({
    @JsonKey(name: 'reset_ticket') required String resetTicket,
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _ResetPasswordRequestDto;

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);
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
class SignupLspRequestDto with _$SignupLspRequestDto {
  const factory SignupLspRequestDto({
    @JsonKey(name: 'account_type') @Default('business') String accountType,
    @JsonKey(name: 'business_type') @Default('lsp') String businessType,
    required String email,
    required String password,
    required String name,
    required String timezone,
    required ConsentDto consent,
  }) = _SignupLspRequestDto;

  factory SignupLspRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignupLspRequestDtoFromJson(json);
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
