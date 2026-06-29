import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// Decoded access-token claims — routing/UX only; server is source of truth.
class Claims {
  const Claims({
    required this.sub,
    required this.role,
    required this.expiresAt,
    required this.issuedAt,
    required this.jti,
    this.tenantId,
    this.onboardingRequired = false,
  });

  final String sub;
  final String role;
  final String? tenantId;
  final DateTime expiresAt;
  final DateTime issuedAt;
  final String jti;
  final bool onboardingRequired;

  /// Base64url-decodes the JWT payload. Returns null on malformed tokens.
  static Claims? decodeAccessToken(String jwt) {
    final parts = jwt.split('.');
    if (parts.length < 2) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final payload = jsonDecode(utf8.decode(base64Url.decode(normalized)))
          as Map<String, dynamic>;
      return Claims.fromJson(payload);
    } catch (_) {
      return null;
    }
  }

  factory Claims.fromJson(Map<String, dynamic> json) {
    final exp = json['exp'];
    final iat = json['iat'];
    return Claims(
      sub: json['sub'] as String,
      role: json['role'] as String,
      tenantId: json['tenant_id'] as String?,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (exp is int ? exp : int.parse(exp.toString())) * 1000,
      ),
      issuedAt: DateTime.fromMillisecondsSinceEpoch(
        (iat is int ? iat : int.parse(iat.toString())) * 1000,
      ),
      jti: json['jti'] as String? ?? '',
      onboardingRequired: json['onboarding_required'] as bool? ?? false,
    );
  }
}

@freezed
class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    required Claims claims,
  }) = _AuthSession;

  factory AuthSession.fromTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    final claims = Claims.decodeAccessToken(accessToken);
    if (claims == null) {
      throw const FormatException('Invalid access token');
    }
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      claims: claims,
    );
  }
}

@freezed
class Membership with _$Membership {
  const factory Membership({
    required String tenantId,
    required String tenantName,
    required String role,
  }) = _Membership;

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);
}

/// Wire-level login outcome before the ViewModel maps to [AuthState].
@freezed
sealed class LoginResult with _$LoginResult {
  const factory LoginResult.session(AuthSession session) = LoginSession;
  const factory LoginResult.mfaRequired({
    required bool firstLogin,
    required String mfaToken,
  }) = LoginMfaRequired;
  const factory LoginResult.pickMembership(List<Membership> memberships) =
      LoginPickMembership;
}
