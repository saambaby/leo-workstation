import '../domain/onboarding_models.dart';

/// In-memory store shared by mock auth + onboarding repos (dev only).
class MockOnboardingStore {
  MockOnboardingStore._();
  static final instance = MockOnboardingStore._();

  final _accounts = <String, MockSignupAccount>{};
  final _onboardingComplete = <String>{};

  void registerSignup({
    required String email,
    required SignupPath path,
    String? orgName,
    String? timezone,
  }) {
    _accounts[email.toLowerCase()] = MockSignupAccount(
      path: path,
      verified: false,
      orgName: orgName,
      timezone: timezone,
    );
  }

  void markVerified(String email) {
    final key = email.toLowerCase();
    final account = _accounts[key];
    if (account != null) {
      _accounts[key] = account.copyWith(verified: true);
    }
  }

  void markVerifiedByToken() {
    for (final entry in _accounts.entries) {
      if (!entry.value.verified) {
        markVerified(entry.key);
        return;
      }
    }
  }

  MockSignupAccount? lookup(String email) => _accounts[email.toLowerCase()];

  bool isOnboardingComplete(String email) =>
      _onboardingComplete.contains(email.toLowerCase());

  void markOnboardingComplete(String email) {
    _onboardingComplete.add(email.toLowerCase());
  }

  void markOnboardingCompleteBySub(String sub) {
    for (final entry in _accounts.entries) {
      if (_subForEmail(entry.key) == sub) {
        markOnboardingComplete(entry.key);
        return;
      }
    }
  }

  String _subForEmail(String email) => 'signup-${email.toLowerCase().hashCode}';

  bool isOnboardingCompleteForSub(String sub) {
    for (final entry in _accounts.entries) {
      if (_subForEmail(entry.key) == sub) {
        return isOnboardingComplete(entry.key);
      }
    }
    return false;
  }

  bool isSignupEmail(String email) => _accounts.containsKey(email.toLowerCase());
}

class MockSignupAccount {
  const MockSignupAccount({
    required this.path,
    required this.verified,
    this.orgName,
    this.timezone,
  });

  final SignupPath path;
  final bool verified;
  final String? orgName;
  final String? timezone;

  MockSignupAccount copyWith({
    SignupPath? path,
    bool? verified,
    String? orgName,
    String? timezone,
  }) {
    return MockSignupAccount(
      path: path ?? this.path,
      verified: verified ?? this.verified,
      orgName: orgName ?? this.orgName,
      timezone: timezone ?? this.timezone,
    );
  }
}
