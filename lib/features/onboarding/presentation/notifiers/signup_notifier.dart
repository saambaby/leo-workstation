import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/onboarding_repository.dart';
import '../../domain/onboarding_entities.dart';

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

  Future<VerifyEmailPendingContext?> submitPersonal({
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

  Future<VerifyEmailPendingContext?> submitCustomer({
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

  Future<VerifyEmailPendingContext?> _submit(
    Future<SignupResult> Function() call,
    String email,
    SignupPath path,
  ) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await call();
      state = const SignupUiState();
      if (!result.emailVerificationRequired) return null;
      return VerifyEmailPendingContext(
        email: email,
        path: path,
        source: VerifyEmailSource.signup,
      );
    } catch (e) {
      state = SignupUiState(loading: false, error: _mapError(e));
      return null;
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
}
