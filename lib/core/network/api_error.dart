import 'package:dio/dio.dart';

/// Machine-readable API error codes from leo-api (`INV-ERROR-1`).
///
/// Use for branching (redirect, field highlight, session teardown) — not for
/// user-facing copy. Display the server `message` instead.
abstract final class ApiErrorCode {
  static const validationFailed = 'VALIDATION_FAILED';
  static const unauthorized = 'UNAUTHORIZED';
  static const notFound = 'NOT_FOUND';
  static const conflict = 'CONFLICT';
  static const internalError = 'INTERNAL_ERROR';

  static const invalidCredentials = 'INVALID_CREDENTIALS';
  static const emailNotVerified = 'EMAIL_NOT_VERIFIED';
  static const invalidCode = 'INVALID_CODE';
  static const invalidToken = 'INVALID_TOKEN';
  static const tokenReuse = 'TOKEN_REUSE';
  static const sessionRevoked = 'SESSION_REVOKED';
  static const invalidTotp = 'INVALID_TOTP';
  static const emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const invalidInvitation = 'INVALID_INVITATION';
  static const consentRequired = 'CONSENT_REQUIRED';
}

/// Parsed `{ statusCode, message, error, code }` envelope from leo-api.
class ApiErrorBody {
  const ApiErrorBody({
    required this.statusCode,
    required this.message,
    required this.error,
    required this.code,
  });

  final int statusCode;
  final String message;
  final String error;
  final String code;

  static ApiErrorBody? tryParse(Object? data) {
    if (data is! Map) return null;
    final map = Map<Object?, Object?>.from(data);
    final code = map['code'];
    final message = _coerceMessage(map['message']);
    if (code is! String || code.isEmpty || message == null) return null;

    final statusRaw = map['statusCode'];
    final errorRaw = map['error'];
    return ApiErrorBody(
      statusCode: statusRaw is int ? statusRaw : 0,
      message: message,
      error: errorRaw is String ? errorRaw : '',
      code: code,
    );
  }

  static String? _coerceMessage(Object? raw) {
    if (raw is String && raw.isNotEmpty) return raw;
    if (raw is List && raw.isNotEmpty) {
      return raw.map((e) => e.toString()).join('; ');
    }
    return null;
  }
}

ApiErrorBody? apiErrorBody(DioException e) =>
    ApiErrorBody.tryParse(e.response?.data);

String? apiErrorCode(DioException e) => apiErrorBody(e)?.code;

String? apiErrorMessage(DioException e) => apiErrorBody(e)?.message;

bool hasApiErrorCode(DioException e, String code) =>
    apiErrorCode(e) == code;

bool isEmailNotVerified(DioException e) =>
    hasApiErrorCode(e, ApiErrorCode.emailNotVerified);

/// User-facing copy from a caught error.
///
/// Prefers the server `message` from the typed envelope. [fallback] is only
/// for non-envelope failures (network, malformed body). Do not map `code` to
/// copy here — the API already sends good messages.
String mapUserFacingError(Object error, {String? fallback}) {
  if (error is DioException) {
    final message = apiErrorMessage(error);
    if (message != null && message.isNotEmpty) return message;
  }
  return fallback ?? 'Something went wrong. Please try again.';
}
