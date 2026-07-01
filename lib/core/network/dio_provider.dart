import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

/// In-memory access-token holder (INV-CLIENT-AUTH-4). core-shell DEFINES it and
/// the dio interceptor READS it; the `auth` feature is the SOLE WRITER (sets on
/// every mint/refresh/switch, clears on logout). Never persisted.
final currentAccessTokenProvider = StateProvider<String?>((ref) => null);

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // Single Bearer path (INV-CLIENT-AUTH-2): inject when a token is present, omit otherwise.
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(currentAccessTokenProvider);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          options.headers.remove('Authorization');
        }
        handler.next(options);
      },
    ),
  );

  // Certificate pinning (INV-CLIENT-NET-1).
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) =>
          pinMatches(cert.der, config);
      return client;
    },
  );

  return dio;
});

/// Pure pin check (testable). With no pins configured, allow ONLY in a debug
/// build — never a silent bypass in a release build.
bool pinMatches(List<int> certDer, AppConfig config) {
  if (config.certPinsSha256.isEmpty) {
    return kDebugMode;
  }
  final fingerprint = base64.encode(sha256.convert(certDer).bytes);
  return config.certPinsSha256.contains(fingerprint);
}
