import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable app configuration sourced at compile time via `--dart-define`.
/// Owns the integration contract's env surface (P1-T-01).
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.realtimeWsUrl,
    required this.webAdminBaseUrl,
    required this.useMocks,
    this.certPinsSha256 = const [],
  });

  final String apiBaseUrl;
  final String realtimeWsUrl;

  /// Single source for the `lsp_admin` "Admin dashboard" link (core-shell) and
  /// the router `platform_admin` `/web-handoff` interstitial. Empty = unset.
  final String webAdminBaseUrl;

  /// Default true (release-plan mock strategy) — UI builds without a backend.
  final bool useMocks;

  /// Base64 SHA-256 cert pins (rotation list). Empty = no pins configured.
  final List<String> certPinsSha256;

  factory AppConfig.fromEnvironment() {
    const pins = String.fromEnvironment('CERT_PINS_SHA256');
    return AppConfig(
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://staging.api.leoconnexio.com/api/v1',
      ),
      realtimeWsUrl: const String.fromEnvironment(
        'REALTIME_WS_URL',
        defaultValue: 'wss://staging.api.leoconnexio.com/realtime',
      ),
      webAdminBaseUrl: const String.fromEnvironment('WEB_ADMIN_BASE_URL'),
      useMocks: const bool.fromEnvironment('USE_MOCKS', defaultValue: true),
      certPinsSha256: pins.isEmpty ? const [] : pins.split(','),
    );
  }
}

final appConfigProvider =
    Provider<AppConfig>((ref) => AppConfig.fromEnvironment());
