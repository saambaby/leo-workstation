import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/data/auth_repository.dart';
import '../../../../core/network/api_error.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../domain/onboarding_entities.dart';

final signupNotifierProvider =
    NotifierProvider<SignupNotifier, SignupUiState>(SignupNotifier.new);

class SignupUiState {
  const SignupUiState({
    this.loading = false,
    this.resendVerifySending = false,
    this.error,
  });

  final bool loading;
  final bool resendVerifySending;
  final String? error;

  SignupUiState copyWith({
    bool? loading,
    bool? resendVerifySending,
    String? error,
  }) {
    return SignupUiState(
      loading: loading ?? this.loading,
      resendVerifySending: resendVerifySending ?? this.resendVerifySending,
      error: error,
    );
  }
}

class SignupNotifier extends Notifier<SignupUiState> {
  @override
  SignupUiState build() => const SignupUiState();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<bool> submitPersonal({
    required String email,
    required String password,
    required bool tos,
    required bool privacy,
  }) async {
    return _submit(
      () => _repo.signupPersonal(
        email: email,
        password: password,
        tos: tos,
        privacy: privacy,
      ),
      email,
      SignupPath.personal,
    );
  }

  Future<bool> submitCustomer({
    required String email,
    required String password,
    required String orgName,
    required String timezone,
    required bool tos,
    required bool privacy,
  }) async {
    return _submit(
      () => _repo.signupCustomer(
        email: email,
        password: password,
        orgName: orgName,
        timezone: timezone,
        tos: tos,
        privacy: privacy,
      ),
      email,
      SignupPath.customer,
    );
  }

  Future<bool> _submit(
    Future<SignupResult> Function() call,
    String email,
    SignupPath path,
  ) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await call();
      state = const SignupUiState();
      if (!result.emailVerificationRequired) return false;
      ref.read(authNotifierProvider.notifier).setEmailVerificationPending(
            VerifyEmailPendingContext(
              email: email,
              path: path,
              source: VerifyEmailSource.signup,
            ),
          );
      return true;
    } catch (e) {
      state = SignupUiState(
        loading: false,
        error: mapUserFacingError(e),
      );
      return false;
    }
  }

  Future<bool> verifyEmail({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await _repo.verifyEmail(email: email, code: code);
      await ref.read(authNotifierProvider.notifier).applyLoginResult(
            result,
            email: email,
            fromEmailVerify: true,
          );
      state = const SignupUiState();
      return true;
    } catch (e) {
      state = SignupUiState(
        loading: false,
        error: mapUserFacingError(
          e,
          fallback: 'Invalid or expired verification code',
        ),
      );
      return false;
    }
  }

  Future<void> resendVerifyEmail({required String email}) async {
    state = state.copyWith(resendVerifySending: true, error: null);
    try {
      await _repo.resendVerifyEmail(email: email);
    } finally {
      state = state.copyWith(resendVerifySending: false);
    }
  }
}
