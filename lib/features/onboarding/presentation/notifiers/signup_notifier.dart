import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/data/auth_repository.dart';
import '../../../../core/network/api_error.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../domain/onboarding_entities.dart';
import '../state/signup_state.dart';
import '../state/signup_ui_state.dart';

export '../state/signup_ui_state.dart';

final signupNotifierProvider =
    NotifierProvider<SignupNotifier, SignupState>(SignupNotifier.new);

/// Derived UI helpers from [SignupState] — screens watch this instead of
/// reading raw notifier loading/error fields.
final signupUiProvider = Provider<SignupUiState>((ref) {
  final state = ref.watch(signupNotifierProvider);
  return SignupUiState.from(state);
});

class SignupNotifier extends Notifier<SignupState> {
  @override
  SignupState build() => const SignupState();

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
      state = const SignupState();
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
      state = SignupState(
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
      state = const SignupState();
      return true;
    } catch (e) {
      state = SignupState(
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
      state = state.copyWith(resendVerifySending: false);
    } catch (e) {
      state = SignupState(
        resendVerifySending: false,
        error: mapUserFacingError(e),
      );
    }
  }
}
