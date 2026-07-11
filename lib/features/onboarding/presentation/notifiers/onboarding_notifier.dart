import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../data/onboarding_repository.dart';
import '../../domain/onboarding_entities.dart';
import '../state/onboarding_state.dart';
import '../state/onboarding_ui_state.dart';

export '../state/onboarding_ui_state.dart';

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);

/// Derived UI helpers from [OnboardingState] — screens watch this instead of
/// reading raw notifier loading/error/catalog fields.
final onboardingUiProvider = Provider<OnboardingUiState>((ref) {
  final state = ref.watch(onboardingNotifierProvider);
  return OnboardingUiState.from(state);
});

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    Future.microtask(loadCatalog);
    return const OnboardingState();
  }

  OnboardingRepository get _repo => ref.read(onboardingRepositoryProvider);

  Future<void> loadCatalog() async {
    if (state.catalogLoaded) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final langs = await _repo.fetchLanguages();
      final certs = await _repo.fetchCertifications();
      state = OnboardingState(
        languages: langs,
        certifications: certs,
        catalogLoaded: true,
      );
    } catch (_) {
      state = const OnboardingState(
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
