import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_storage.dart';

/// Persists onboarding completion until backend emits `onboarding_required` on JWT.
class OnboardingCompletionStorage {
  OnboardingCompletionStorage(this._storage);

  final FlutterSecureStorage _storage;
  static const _prefix = 'leo.onboarding_complete.';

  Future<void> markComplete(String userId) =>
      _storage.write(key: '$_prefix$userId', value: '1');

  Future<bool> isComplete(String userId) async =>
      (await _storage.read(key: '$_prefix$userId')) == '1';

  Future<void> clear(String userId) =>
      _storage.delete(key: '$_prefix$userId');
}

final onboardingCompletionStorageProvider =
    Provider<OnboardingCompletionStorage>((ref) {
  return OnboardingCompletionStorage(ref.watch(flutterSecureStorageProvider));
});
