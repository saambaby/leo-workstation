import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/signup_notifier.dart';

class SignupUiStateView {
  const SignupUiStateView({
    required this.isLoading,
    this.errorMessage,
    this.resendVerifySending = false,
  });

  final bool isLoading;
  final String? errorMessage;
  final bool resendVerifySending;

  factory SignupUiStateView.from(SignupUiState state) {
    return SignupUiStateView(
      isLoading: state.loading || state.resendVerifySending,
      errorMessage: state.error,
      resendVerifySending: state.resendVerifySending,
    );
  }
}

final signupUiProvider = Provider<SignupUiStateView>((ref) {
  final state = ref.watch(signupNotifierProvider);
  return SignupUiStateView.from(state);
});
