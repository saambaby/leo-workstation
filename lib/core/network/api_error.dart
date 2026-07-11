import 'package:dio/dio.dart';

/// Extracts the API error `message` field from a [DioException] response body.
String? apiErrorMessage(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    final m = data['message'];
    if (m is String) return m;
  }
  return null;
}

bool isEmailNotVerified(DioException e) {
  return e.response?.statusCode == 401 &&
      apiErrorMessage(e) == 'Email not verified';
}

String mapUserFacingError(Object error, {String? fallback}) {
  if (error is DioException) {
    final status = error.response?.statusCode;
    final message = apiErrorMessage(error);
    if (message != null && message.isNotEmpty) return message;
    if (status == 401) return 'Invalid email or password';
    if (status == 404) return 'Workspace not found or no longer available';
    if (status == 409) return 'An account with this email already exists';
    if (status == 400) return 'Please check your details and try again';
  }
  return fallback ?? 'Something went wrong. Please try again.';
}
