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
