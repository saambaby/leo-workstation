import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/onboarding_entities.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(false) bool loading,
    String? error,
    @Default([]) List<CatalogLanguage> languages,
    @Default([]) List<CatalogCertification> certifications,
    @Default(false) bool catalogLoaded,
  }) = _OnboardingState;
}
