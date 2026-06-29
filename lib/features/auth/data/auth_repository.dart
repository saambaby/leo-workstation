import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/leo_roles.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/auth_models.dart';

abstract class AuthRepository {
  Future<LoginResult> login({required String email, required String password});

  Future<AuthSession> submitMfa({
    required String mfaToken,
    required String code,
  });

  Future<AuthSession> refreshSession({required String refreshToken});

  Future<AuthSession> selectMembership({
    required String tenantId,
    required String role,
  });

  Future<LoginResult> switchTenant({
    required String tenantId,
    String? mfaToken,
  });

  Future<void> logout({required String refreshToken});

  Future<List<Membership>> listMemberships();

  Future<void> forgotPassword({required String email});

  Future<AuthSession> resetPassword({
    required String token,
    required String password,
  });

  Future<AuthSession> acceptInvite({
    required String token,
    required String password,
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
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return _mapLoginResponse(response.data!);
  }

  @override
  Future<AuthSession> submitMfa({
    required String mfaToken,
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/mfa',
      data: {'mfa_token': mfaToken, 'code': code},
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
  Future<AuthSession> selectMembership({
    required String tenantId,
    required String role,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/switch-tenant',
      data: {'tenant_id': tenantId},
    );
    return _sessionFromResponse(response.data!);
  }

  @override
  Future<LoginResult> switchTenant({
    required String tenantId,
    String? mfaToken,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/switch-tenant',
      data: {
        'tenant_id': tenantId,
        'mfa_token': ?mfaToken,
      },
    );
    final data = response.data!;
    if (data['mfa_required'] == true) {
      return LoginResult.mfaRequired(
        firstLogin: false,
        mfaToken: data['mfa_token'] as String,
      );
    }
    return LoginResult.session(_sessionFromResponse(data));
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    await _dio.post<void>(
      '/auth/logout',
      data: {'refresh_token': refreshToken},
    );
  }

  @override
  Future<List<Membership>> listMemberships() async {
    final response = await _dio.get<List<dynamic>>('/auth/memberships');
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(Membership.fromJson)
        .toList();
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dio.post<void>('/auth/forgot-password', data: {'email': email});
  }

  @override
  Future<AuthSession> resetPassword({
    required String token,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/reset-password',
      data: {'token': token, 'password': password},
    );
    return _sessionFromResponse(response.data!);
  }

  @override
  Future<AuthSession> acceptInvite({
    required String token,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/invitations/accept',
      data: {'token': token, 'password': password},
    );
    return _sessionFromResponse(response.data!);
  }

  LoginResult _mapLoginResponse(Map<String, dynamic> data) {
    if (data['mfa_required'] == true) {
      return LoginResult.mfaRequired(
        firstLogin: data['first_login'] as bool? ?? false,
        mfaToken: data['mfa_token'] as String,
      );
    }
    final memberships = data['memberships'];
    if (memberships is List && memberships.length > 1) {
      return LoginResult.pickMembership(
        memberships
            .cast<Map<String, dynamic>>()
            .map(Membership.fromJson)
            .toList(),
      );
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

  String? _pendingEmail;

  static const _mockMemberships = [
    Membership(
      tenantId: '11111111-1111-1111-1111-111111111111',
      tenantName: 'Acme Language Services',
      role: LeoRoles.lspAdmin,
    ),
    Membership(
      tenantId: '22222222-2222-2222-2222-222222222222',
      tenantName: 'Northlight Interpreting',
      role: LeoRoles.interpreter,
    ),
  ];

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _pendingEmail = email;

    if (password.isEmpty || !email.contains('@')) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
        ),
      );
    }

    if (email.startsWith('multi@')) {
      return LoginResult.pickMembership(_mockMemberships);
    }

    if (email.startsWith('mfa@')) {
      return LoginResult.mfaRequired(
        firstLogin: email.contains('enroll'),
        mfaToken: 'mock-mfa-token',
      );
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
      return LoginResult.session(
        _mockSession(role: LeoRoles.interpreter),
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
  Future<AuthSession> submitMfa({
    required String mfaToken,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (code.length != 6) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/mfa'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/mfa'),
          statusCode: 401,
        ),
      );
    }
    final role = _pendingEmail?.startsWith('admin@') == true
        ? LeoRoles.lspAdmin
        : LeoRoles.subAdmin;
    return _mockSession(
      role: role,
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
  Future<AuthSession> selectMembership({
    required String tenantId,
    required String role,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (roleRequiresMfa(role)) {
      throw StateError('Privileged membership requires MFA via submitMfa');
    }
    return _mockSession(role: role, tenantId: tenantId);
  }

  @override
  Future<LoginResult> switchTenant({
    required String tenantId,
    String? mfaToken,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final membership = _mockMemberships.firstWhere(
      (m) => m.tenantId == tenantId,
      orElse: () => throw DioException(
        requestOptions: RequestOptions(path: '/auth/switch-tenant'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/switch-tenant'),
          statusCode: 404,
        ),
      ),
    );

    if (roleRequiresMfa(membership.role) && mfaToken == null) {
      return const LoginResult.mfaRequired(
        firstLogin: false,
        mfaToken: 'mock-switch-mfa-token',
      );
    }

    return LoginResult.session(
      _mockSession(role: membership.role, tenantId: tenantId),
    );
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<List<Membership>> listMemberships() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _mockMemberships;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<AuthSession> resetPassword({
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
    return _mockSession(role: LeoRoles.interpreter);
  }

  @override
  Future<AuthSession> acceptInvite({
    required String token,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _mockSession(
      role: LeoRoles.interpreter,
      tenantId: '22222222-2222-2222-2222-222222222222',
    );
  }

  AuthSession _mockSession({
    required String role,
    String? tenantId,
    bool onboardingRequired = false,
  }) {
    final accessToken = _mockJwt(
      role: role,
      tenantId: tenantId,
      onboardingRequired: onboardingRequired,
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
  }) {
    final header = base64Url.encode(utf8.encode('{"alg":"none"}'));
    final payload = base64Url.encode(
      utf8.encode(
        jsonEncode({
          'sub': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
          'role': role,
          'tenant_id': ?tenantId,
          'exp': DateTime.now()
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
