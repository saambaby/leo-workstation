import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the refresh token only — never the access token (INV-CLIENT-AUTH-1),
/// and never logs it (INV-CLIENT-PHI-1).
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;
  static const _refreshKey = 'leo.refresh_token';

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshKey, value: token);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> clear() => _storage.delete(key: _refreshKey);
}

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(flutterSecureStorageProvider)),
);
