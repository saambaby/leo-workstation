import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/core/network/dio_provider.dart';
import 'package:leo_workstation/core/storage/token_storage.dart';

/// In-memory FlutterSecureStorage for the round-trip test.
class _InMemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String?> _m = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _m[key] = value;
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _m[key];

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _m.remove(key);
  }
}

void main() {
  group('dio Bearer interceptor (INV-CLIENT-AUTH-2/4)', () {
    InterceptorsWrapper bearerInterceptor(ProviderContainer c) =>
        c.read(dioProvider).interceptors.whereType<InterceptorsWrapper>().first;

    test('injects Authorization when the token holder is set', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(currentAccessTokenProvider.notifier).state = 'abc123';
      final options = RequestOptions(path: '/sessions');
      bearerInterceptor(c).onRequest(options, RequestInterceptorHandler());
      expect(options.headers['Authorization'], 'Bearer abc123');
    });

    test('omits Authorization when the token holder is null/empty', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final options = RequestOptions(path: '/sessions');
      bearerInterceptor(c).onRequest(options, RequestInterceptorHandler());
      expect(options.headers.containsKey('Authorization'), isFalse);

      c.read(currentAccessTokenProvider.notifier).state = '';
      final options2 = RequestOptions(path: '/sessions');
      bearerInterceptor(c).onRequest(options2, RequestInterceptorHandler());
      expect(options2.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('TokenStorage round-trip (INV-CLIENT-AUTH-1)', () {
    test('save -> read -> clear', () async {
      final storage = TokenStorage(_InMemorySecureStorage());
      expect(await storage.readRefreshToken(), isNull);
      await storage.saveRefreshToken('refresh-xyz');
      expect(await storage.readRefreshToken(), 'refresh-xyz');
      await storage.clear();
      expect(await storage.readRefreshToken(), isNull);
    });
  });
}
