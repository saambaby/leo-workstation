import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/leo_roles.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/dio_provider.dart';
import '../../onboarding/data/mock_onboarding_store.dart';
import '../../onboarding/domain/onboarding_models.dart';
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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useMocks) {
    return MockAuthRepository();
  }
  return ApiAuthRepository(ref.watch(dioProvider));
});

/// Live wire implementation — used when `USE_MOCKS=false`.
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

/// Deterministic mock for UI development (`USE_MOCKS=true`, default).
class MockAuthRepository implements AuthRepository {
  MockAuthRepository();

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
    String? totpCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (password.isEmpty || !email.contains('@')) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
        ),
      );
    }

    if (email.startsWith('mfa@')) {
      if (totpCode != null) {
        if (totpCode.length != 6) {
          throw DioException(
            requestOptions: RequestOptions(path: '/auth/login'),
            response: Response(
              requestOptions: RequestOptions(path: '/auth/login'),
              statusCode: 401,
            ),
          );
        }
        return LoginResult.session(
          _mockSession(
            role: LeoRoles.lspAdmin,
            tenantId: '11111111-1111-1111-1111-111111111111',
          ),
        );
      }
      if (email.contains('enroll')) {
        return const LoginResult.mfaRequired(
          firstLogin: true,
          enrollmentToken: 'mock-enrollment-token',
          otpauthUrl:
              'otpauth://totp/Leo:mfa@example.com?secret=MOCKSECRET&issuer=Leo',
          secret: 'MOCKSECRET',
        );
      }
      return const LoginResult.mfaRequired(firstLogin: false);
    }

    if (email.startsWith('admin@')) {
      return LoginResult.session(
        _mockSession(
          role: LeoRoles.lspAdmin,
          tenantId: '11111111-1111-1111-1111-111111111111',
        ),
      );
    }

    if (email.startsWith('tenantless@')) {
      return LoginResult.session(_mockSession(role: LeoRoles.interpreter));
    }

    final signup = MockOnboardingStore.instance.lookup(email);
    if (signup != null) {
      if (!signup.verified) {
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 401,
          ),
        );
      }
      final sub = 'signup-${email.toLowerCase().hashCode}';
      final needsOnboarding = !MockOnboardingStore.instance
          .isOnboardingComplete(email);
      if (signup.path == SignupPath.personal) {
        return LoginResult.session(
          _mockSession(
            role: LeoRoles.interpreter,
            sub: sub,
            onboardingRequired: needsOnboarding,
          ),
        );
      }
      return LoginResult.session(
        _mockSession(
          role: LeoRoles.customerAdmin,
          tenantId: '33333333-3333-3333-3333-333333333333',
          sub: sub,
          onboardingRequired: needsOnboarding,
        ),
      );
    }

    return LoginResult.session(
      _mockSession(
        role: LeoRoles.interpreter,
        tenantId: '22222222-2222-2222-2222-222222222222',
      ),
    );
  }

  @override
  Future<AuthSession> completeMfaEnrollment({
    required String enrollmentToken,
    required String totpCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (totpCode.length != 6) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/mfa/enroll'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/mfa/enroll'),
          statusCode: 400,
        ),
      );
    }
    return _mockSession(
      role: LeoRoles.lspAdmin,
      tenantId: '11111111-1111-1111-1111-111111111111',
    );
  }

  @override
  Future<AuthSession> refreshSession({required String refreshToken}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (refreshToken.isEmpty || refreshToken == 'expired') {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 401,
        ),
      );
    }
    return _mockSession(
      role: LeoRoles.interpreter,
      tenantId: '22222222-2222-2222-2222-222222222222',
    );
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (token == 'expired') {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/reset-password'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/reset-password'),
          statusCode: 410,
        ),
      );
    }
    if (token != '123456') {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/reset-password'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/reset-password'),
          statusCode: 400,
        ),
      );
    }
    if (password.length < 8) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/reset-password'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/reset-password'),
          statusCode: 400,
        ),
      );
    }
  }

  @override
  Future<void> acceptInvite({
    required String token,
    required String password,
    required bool tos,
    required bool privacy,
    required bool baaAck,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!tos || !privacy || !baaAck) {
      throw DioException(
        requestOptions: RequestOptions(path: '/invitations/accept'),
        response: Response(
          requestOptions: RequestOptions(path: '/invitations/accept'),
          statusCode: 400,
        ),
      );
    }
  }

  AuthSession _mockSession({
    required String role,
    String? tenantId,
    bool onboardingRequired = false,
    String sub = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  }) {
    final accessToken = _mockJwt(
      role: role,
      tenantId: tenantId,
      onboardingRequired: onboardingRequired,
      sub: sub,
    );
    return AuthSession.fromTokens(
      accessToken: accessToken,
      refreshToken: 'mock-refresh-${tenantId ?? 'tenantless'}',
    );
  }

  String _mockJwt({
    required String role,
    String? tenantId,
    bool onboardingRequired = false,
    String sub = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  }) {
    final header = base64Url.encode(utf8.encode('{"alg":"none"}'));
    final payload = base64Url.encode(
      utf8.encode(
        jsonEncode({
          'sub': sub,
          'role': role,
          'tenant_id': ?tenantId,
          'exp':
              DateTime.now()
                  .add(const Duration(hours: 1))
                  .millisecondsSinceEpoch ~/
              1000,
          'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'jti': 'mock-jti',
          'onboarding_required': onboardingRequired,
        }),
      ),
    );
    return '$header.$payload.mock-signature';
  }
}
