import 'package:freezed_annotation/freezed_annotation.dart';

import 'signup_state.dart';

part 'signup_ui_state.freezed.dart';

/// Derived UI helpers from [SignupState] — screens watch this instead of
/// reading raw notifier loading/error fields.
@freezed
class SignupUiState with _$SignupUiState {
  const factory SignupUiState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool resendVerifySending,
  }) = _SignupUiState;

  factory SignupUiState.from(SignupState state) => SignupUiState(
        isLoading: state.loading || state.resendVerifySending,
        errorMessage: state.error,
        resendVerifySending: state.resendVerifySending,
      );
}
