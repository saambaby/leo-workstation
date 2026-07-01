import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/auth_models.dart';

abstract class AuthRepository {
  /// Resubmit with [totpCode] to complete a privileged login already
  /// MFA-challenged — the real backend has no separate verify endpoint.
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

  Future<void> resetPassword({required String token, required String password});

  /// Creates the membership; does not mint tokens — the caller logs in
  /// afterward.
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
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password, 'totp_code': ?totpCode},
    );
    return _mapLoginResponse(response.data!);
  }

  @override
  Future<AuthSession> completeMfaEnrollment({
    required String enrollmentToken,
    required String totpCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/mfa/enroll',
      data: {'enrollment_token': enrollmentToken, 'totp_code': totpCode},
    );
    return _sessionFromResponse(response.data!);
  }

  @override
  Future<AuthSession> refreshSession({required String refreshToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return _sessionFromResponse(response.data!);
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    await _dio.post<void>(
      '/auth/logout',
      data: {'refresh_token': refreshToken},
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dio.post<void>('/auth/forgot-password', data: {'email': email});
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _dio.post<void>(
      '/auth/reset-password',
      data: {'token': token, 'new_password': password},
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
      data: {
        'token': token,
        'password': password,
        'consent': {'tos': tos, 'privacy': privacy, 'baa_ack': baaAck},
      },
    );
  }

  LoginResult _mapLoginResponse(Map<String, dynamic> data) {
    if (data['mfa_enrollment_required'] == true) {
      return LoginResult.mfaRequired(
        firstLogin: true,
        enrollmentToken: data['enrollment_token'] as String,
        otpauthUrl: data['otpauth_url'] as String,
        secret: data['secret'] as String,
      );
    }
    if (data['mfa_required'] == true) {
      return const LoginResult.mfaRequired(firstLogin: false);
    }
    return LoginResult.session(_sessionFromResponse(data));
  }

  AuthSession _sessionFromResponse(Map<String, dynamic> data) {
    return AuthSession.fromTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
  }
}
