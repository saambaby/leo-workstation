import 'package:go_router/go_router.dart';

import '../../../../core/router/device_class_scope.dart';
import '../../domain/onboarding_entities.dart';
import '../screens/customer_onboarding_screen.dart';
import '../screens/personal_onboarding_screen.dart';
import '../screens/signup_details_screen.dart';
import '../screens/signup_type_screen.dart';
import '../screens/verify_email_screen.dart';

const onboardingPublicRoutes = {
  '/signup',
  '/signup/details',
  '/verify-email',
};

List<RouteBase> get onboardingRoutes => [
  GoRoute(
    path: '/onboarding/personal',
    builder: (_, _) =>
        const DeviceClassScope(child: PersonalOnboardingScreen()),
  ),
  GoRoute(
    path: '/onboarding/customer',
    builder: (_, _) =>
        const DeviceClassScope(child: CustomerOnboardingScreen()),
  ),
  GoRoute(
    path: '/signup',
    builder: (_, _) => const DeviceClassScope(child: SignupTypeScreen()),
    routes: [
      GoRoute(
        path: 'details',
        builder: (_, state) => DeviceClassScope(
          child: SignupDetailsScreen(draft: state.extra! as SignupDraft),
        ),
      ),
    ],
  ),
  GoRoute(
    path: '/verify-email',
    builder: (_, state) {
      final extra = state.extra as VerifyEmailPendingContext?;
      if (extra != null) {
        return DeviceClassScope(
          child: VerifyEmailScreen(pendingContext: extra),
        );
      }
      final email = state.uri.queryParameters['email'] ?? '';
      final sourceParam = state.uri.queryParameters['source'];
      final source = sourceParam == 'login'
          ? VerifyEmailSource.login
          : VerifyEmailSource.signup;
      final pathParam = state.uri.queryParameters['path'];
      final path = switch (pathParam) {
        'customer' => SignupPath.customer,
        'lsp' => SignupPath.lsp,
        _ => SignupPath.personal,
      };
      return DeviceClassScope(
        child: VerifyEmailScreen(
          pendingContext: VerifyEmailPendingContext(
            email: email,
            source: source,
            path: path,
          ),
        ),
      );
    },
  ),
];
