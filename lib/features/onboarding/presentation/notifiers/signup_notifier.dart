import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/onboarding_repository.dart';
import '../../domain/onboarding_models.dart';

final signupNotifierProvider =
    NotifierProvider<SignupNotifier, SignupUiState>(SignupNotifier.new);

class SignupUiState {
  const SignupUiState({
    this.loading = false,
    this.error,
  });

  final bool loading;
  final String? error;

  SignupUiState copyWith({bool? loading, String? error}) {
    return SignupUiState(
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class SignupNotifier extends Notifier<SignupUiState> {
  @override
  SignupUiState build() => const SignupUiState();

  OnboardingRepository get _repo => ref.read(onboardingRepositoryProvider);

  Future<SignupVerifyContext?> submitPersonal({
    required String email,
    required String password,
    required bool tos,
    required bool privacy,
  }) async {
    return _submit(() => _repo.signupPersonal(
          email: email,
          password: password,
          tos: tos,
          privacy: privacy,
        ), email, SignupPath.personal);
  }

  Future<SignupVerifyContext?> submitCustomer({
    required String email,
    required String password,
    required String orgName,
    required String timezone,
    required bool tos,
    required bool privacy,
  }) async {
    return _submit(() => _repo.signupCustomer(
          email: email,
          password: password,
          orgName: orgName,
          timezone: timezone,
          tos: tos,
          privacy: privacy,
        ), email, SignupPath.customer);
  }

  Future<SignupVerifyContext?> _submit(
    Future<SignupResult> Function() call,
    String email,
    SignupPath path,
  ) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await call();
      state = const SignupUiState();
      return SignupVerifyContext(email: email, path: path);
    } catch (e) {
      state = SignupUiState(loading: false, error: _mapError(e));
      return null;
    }
  }

  Future<bool> verifyEmail({
    required String token,
    required String email,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.verifyEmail(token: token, email: email);
      state = const SignupUiState();
      return true;
    } catch (e) {
      state = SignupUiState(loading: false, error: _mapVerifyError(e));
      return false;
    }
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 409) return 'An account with this email already exists';
      if (status == 400) return 'Please check your details and try again';
    }
    return 'Something went wrong. Please try again.';
  }

  String _mapVerifyError(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 400) return 'Invalid or expired verification code';
    }
    return 'Something went wrong. Please try again.';
  }
}
