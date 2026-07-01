import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/core/device/device_class.dart';
import 'package:leo_workstation/core/router/redirect.dart';
import 'package:leo_workstation/features/auth/presentation/state/auth_state.dart';

void main() {
  group('signup public routes', () {
    test('unauthenticated user can access signup funnel paths', () {
      for (final path in [
        '/signup',
        '/signup/details',
        '/verify-email',
      ]) {
        expect(
          authRedirect(
            const AuthState.unauthenticated(),
            DeviceClass.desktop,
            path,
          ),
          isNull,
          reason: path,
        );
      }
    });
  });
}
