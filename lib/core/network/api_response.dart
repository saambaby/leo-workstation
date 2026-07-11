import 'package:dio/dio.dart';

/// Requires a non-null JSON object body from a successful Dio response.
///
/// Prefer this over `response.data!` — empty/unexpected bodies become a
/// typed [DioException] instead of a late null crash inside `fromJson`.
Map<String, dynamic> requireJsonMap(
  Response<dynamic> response, {
  required String endpoint,
}) {
  final data = response.data;
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  throw DioException(
    requestOptions: response.requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
    message: 'Expected JSON object from $endpoint',
  );
}

/// Requires a non-null JSON array body from a successful Dio response.
List<dynamic> requireJsonList(
  Response<dynamic> response, {
  required String endpoint,
}) {
  final data = response.data;
  if (data is List<dynamic>) return data;
  if (data is List) return List<dynamic>.from(data);
  throw DioException(
    requestOptions: response.requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
    message: 'Expected JSON array from $endpoint',
  );
}
