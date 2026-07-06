import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/core/config/app_config.dart';
import 'package:leo_workstation/core/device/device_class.dart';
import 'package:leo_workstation/core/network/dio_provider.dart';

void main() {
  group('DeviceClass breakpoints', () {
    test('classifies by shortest side', () {
      expect(deviceClassFor(0), DeviceClass.smartphone);
      expect(deviceClassFor(599), DeviceClass.smartphone);
      expect(deviceClassFor(600), DeviceClass.tablet);
      expect(deviceClassFor(1023), DeviceClass.tablet);
      expect(deviceClassFor(1024), DeviceClass.desktop);
      expect(deviceClassFor(2560), DeviceClass.desktop);
    });
  });

  group('Cert pinning (pinMatches)', () {
    final der = utf8.encode('fake-cert-bytes');
    final fp = base64.encode(sha256.convert(der).bytes);

    test('no pins + debug build => allowed (dev escape, never a release bypass)', () {
      const cfg = AppConfig(
        apiBaseUrl: 'x',
        realtimeWsUrl: 'x',
        webAdminBaseUrl: '',
      );
      expect(pinMatches(der, cfg), isTrue);
    });

    test('pins configured => only the matching fingerprint is allowed', () {
      final cfg = AppConfig(
        apiBaseUrl: 'x',
        realtimeWsUrl: 'x',
        webAdminBaseUrl: '',
        certPinsSha256: [fp],
      );
      expect(pinMatches(der, cfg), isTrue);
      expect(pinMatches(utf8.encode('other'), cfg), isFalse);
    });
  });
}
