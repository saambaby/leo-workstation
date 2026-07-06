import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/auth_entities.dart';
import 'dto/auth_dto.dart';

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
      data: LoginRequestDto(
        email: email,
        password: password,
        totpCode: totpCode,
      ).toJson(),
    );
    return LoginResult.fromJson(response.data!);
  }

  @override
  Future<AuthSession> completeMfaEnrollment({
    required String enrollmentToken,
    required String totpCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/mfa/enroll',
      data: MfaEnrollRequestDto(
        enrollmentToken: enrollmentToken,
        totpCode: totpCode,
      ).toJson(),
    );
    return AuthSession.fromJson(response.data!);
  }

  @override
  Future<AuthSession> refreshSession({required String refreshToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: RefreshTokenRequestDto(refreshToken: refreshToken).toJson(),
    );
    return AuthSession.fromJson(response.data!);
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
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _dio.post<void>(
      '/auth/reset-password',
      data: ResetPasswordRequestDto(token: token, newPassword: password)
          .toJson(),
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
