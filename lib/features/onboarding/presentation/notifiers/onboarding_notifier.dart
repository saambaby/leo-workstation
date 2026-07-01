import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../data/onboarding_repository.dart';
import '../../domain/onboarding_models.dart';

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingUiState>(
  OnboardingNotifier.new,
);

class OnboardingUiState {
  const OnboardingUiState({
    this.loading = false,
    this.error,
    this.languages = const [],
    this.certifications = const [],
    this.catalogLoaded = false,
  });

  final bool loading;
  final String? error;
  final List<CatalogLanguage> languages;
  final List<CatalogCertification> certifications;
  final bool catalogLoaded;

  OnboardingUiState copyWith({
    bool? loading,
    String? error,
    List<CatalogLanguage>? languages,
    List<CatalogCertification>? certifications,
    bool? catalogLoaded,
  }) {
    return OnboardingUiState(
      loading: loading ?? this.loading,
      error: error,
      languages: languages ?? this.languages,
      certifications: certifications ?? this.certifications,
      catalogLoaded: catalogLoaded ?? this.catalogLoaded,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingUiState> {
  @override
  OnboardingUiState build() => const OnboardingUiState();

  OnboardingRepository get _repo => ref.read(onboardingRepositoryProvider);

  Future<void> loadCatalog() async {
    if (state.catalogLoaded) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final langs = await _repo.fetchLanguages();
      final certs = await _repo.fetchCertifications();
      state = OnboardingUiState(
        languages: langs,
        certifications: certs,
        catalogLoaded: true,
      );
    } catch (_) {
      state = const OnboardingUiState(
        error: 'Could not load catalog. Please try again.',
      );
    }
  }

  Future<bool> completePersonal(InterpreterProfileInput input) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.saveInterpreterProfile(input);
      await ref.read(authNotifierProvider.notifier).completeOnboarding();
      state = state.copyWith(loading: false);
      return true;
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Could not save profile. Please try again.',
      );
      return false;
    }
  }

  Future<bool> completeCustomer({
    required CustomerOrgInput org,
    required List<TeamInviteInput> invites,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.updateCustomerOrg(org);
      for (final invite in invites) {
        if (invite.email.trim().isNotEmpty) {
          await _repo.sendInvitation(invite);
        }
      }
      await ref.read(authNotifierProvider.notifier).completeOnboarding();
      state = state.copyWith(loading: false);
      return true;
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Could not finish setup. Please try again.',
      );
      return false;
    }
  }
}
