import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/api_response.dart';
import '../../network/dio_provider.dart';
import '../domain/auth_entities.dart';
import '../domain/signup_entities.dart';
import 'dto/auth_dto.dart';

/// Shared wire layer for all `/auth/*` endpoints (`INV-CLIENT-AUTH-REPO-1`).
abstract class AuthRepository {
  Future<LoginResult> login({
    required String email,
    required String password,
    String? totpCode,
  });

  Future<AuthSession> completeMfaEnrollment({
    required String enrollmentToken,
    required String totpCode,
  });

  Future<AuthSession> refreshSession({required String refreshToken});

  Future<void> logout({required String refreshToken});

  Future<void> forgotPassword({required String email});

  Future<LoginResult> verifyEmail({
    required String email,
    required String code,
  });

  Future<void> resendVerifyEmail({required String email});

  Future<ResetTicket> verifyResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({
    required String resetTicket,
    required String password,
  });

  Future<SignupResult> signupPersonal({
    required String email,
    required String password,
    required bool tos,
    required bool privacy,
  });

  Future<SignupResult> signupCustomer({
    required String email,
    required String password,
    required String orgName,
    required String timezone,
    required bool tos,
    required bool privacy,
  });

  Future<void> acceptInvite({
    required String token,
    required String password,
    required bool tos,
    required bool privacy,
    required bool baaAck,
  });
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(ref.watch(dioProvider)),
);

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
    String? totpCode,
  }) async {
    const endpoint = '/auth/login';
    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: LoginRequestDto(
        email: email,
        password: password,
        totpCode: totpCode,
      ).toJson(),
    );
    return LoginResult.fromJson(
      requireJsonMap(response, endpoint: endpoint),
    );
  }

  @override
  Future<AuthSession> completeMfaEnrollment({
    required String enrollmentToken,
    required String totpCode,
  }) async {
    const endpoint = '/auth/mfa/enroll';
    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: MfaEnrollRequestDto(
        enrollmentToken: enrollmentToken,
        totpCode: totpCode,
      ).toJson(),
    );
    return AuthSession.fromJson(
      requireJsonMap(response, endpoint: endpoint),
    );
  }

  @override
  Future<AuthSession> refreshSession({required String refreshToken}) async {
    const endpoint = '/auth/refresh';
    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: RefreshTokenRequestDto(refreshToken: refreshToken).toJson(),
    );
    return AuthSession.fromJson(
      requireJsonMap(response, endpoint: endpoint),
    );
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    await _dio.post<void>(
      '/auth/logout',
      data: RefreshTokenRequestDto(refreshToken: refreshToken).toJson(),
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dio.post<void>(
      '/auth/forgot-password',
      data: ForgotPasswordRequestDto(email: email).toJson(),
    );
  }

  @override
  Future<LoginResult> verifyEmail({
    required String email,
    required String code,
  }) async {
    const endpoint = '/auth/verify-email';
    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: VerifyEmailRequestDto(email: email, code: code).toJson(),
    );
    return LoginResult.fromJson(
      requireJsonMap(response, endpoint: endpoint),
    );
  }

  @override
  Future<void> resendVerifyEmail({required String email}) async {
    await _dio.post<void>(
      '/auth/resend-verify',
      data: ResendVerifyEmailRequestDto(email: email).toJson(),
    );
  }

  @override
  Future<ResetTicket> verifyResetCode({
    required String email,
    required String code,
  }) async {
    const endpoint = '/auth/reset-password/verify';
    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: ResetPasswordVerifyRequestDto(email: email, code: code).toJson(),
    );
    return ResetTicket.fromJson(
      requireJsonMap(response, endpoint: endpoint),
    );
  }

  @override
  Future<void> resetPassword({
    required String resetTicket,
    required String password,
  }) async {
    await _dio.post<void>(
      '/auth/reset-password',
      data: ResetPasswordRequestDto(
        resetTicket: resetTicket,
        newPassword: password,
      ).toJson(),
    );
  }

  @override
  Future<SignupResult> signupPersonal({
    required String email,
    required String password,
    required bool tos,
    required bool privacy,
  }) async {
    const endpoint = '/auth/signup';
    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: SignupPersonalRequestDto(
        email: email,
        password: password,
        consent: ConsentDto(tos: tos, privacy: privacy),
      ).toJson(),
    );
    return SignupResult.fromJson(
      requireJsonMap(response, endpoint: endpoint),
    );
  }

  @override
  Future<SignupResult> signupCustomer({
    required String email,
    required String password,
    required String orgName,
    required String timezone,
    required bool tos,
    required bool privacy,
  }) async {
    const endpoint = '/auth/signup';
    final response = await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: SignupCustomerRequestDto(
        email: email,
        password: password,
        name: orgName,
        timezone: timezone,
        consent: ConsentDto(tos: tos, privacy: privacy),
      ).toJson(),
    );
    return SignupResult.fromJson(
      requireJsonMap(response, endpoint: endpoint),
    );
  }

  @override
  Future<void> acceptInvite({
    required String token,
    required String password,
    required bool tos,
    required bool privacy,
    required bool baaAck,
  }) async {
    await _dio.post<void>(
      '/invitations/accept',
      data: InviteAcceptRequestDto(
        token: token,
        password: password,
        consent: ConsentDto(tos: tos, privacy: privacy, baaAck: baaAck),
      ).toJson(),
    );
  }
}
