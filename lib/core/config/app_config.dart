import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable app configuration loaded from `.env` at startup.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.realtimeWsUrl,
    required this.webAdminBaseUrl,
    this.certPinsSha256 = const [],
  });

  final String apiBaseUrl;
  final String realtimeWsUrl;

  /// Single source for the `lsp_admin` "Admin dashboard" external link (core-shell).
  /// Empty = unset. `platform_admin` has no workstation home — rejected at session mint.
  final String webAdminBaseUrl;

  /// Base64 SHA-256 cert pins (rotation list). Empty = no pins configured.
  final List<String> certPinsSha256;

  factory AppConfig.fromDotenv() {
    final pins = dotenv.maybeGet('CERT_PINS_SHA256') ?? '';
    return AppConfig(
      apiBaseUrl: dotenv.get('API_BASE_URL'),
      realtimeWsUrl: dotenv.get('REALTIME_WS_URL'),
      webAdminBaseUrl: dotenv.maybeGet('WEB_ADMIN_BASE_URL') ?? '',
      certPinsSha256: pins.isEmpty ? const [] : pins.split(','),
    );
  }
}

final appConfigProvider =
    Provider<AppConfig>((ref) => AppConfig.fromDotenv());
