import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/onboarding_entities.dart';
import 'onboarding_state.dart';

part 'onboarding_ui_state.freezed.dart';

/// Derived UI helpers from [OnboardingState] — screens watch this instead of
/// reading raw notifier loading/error/catalog fields.
@freezed
class OnboardingUiState with _$OnboardingUiState {
  const factory OnboardingUiState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default([]) List<CatalogLanguage> languages,
    @Default([]) List<CatalogCertification> certifications,
    @Default(false) bool catalogLoaded,
  }) = _OnboardingUiState;

  factory OnboardingUiState.from(OnboardingState s) => OnboardingUiState(
        isLoading: s.loading,
        errorMessage: s.error,
        languages: s.languages,
        certifications: s.certifications,
        catalogLoaded: s.catalogLoaded,
      );
}
