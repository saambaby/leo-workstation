import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/onboarding_models.dart';

abstract class OnboardingRepository {
  Future<SignupResult> signupPersonal({
    required String email,
    required String password,
    required bool tos,
    required bool privacy,
  });

  Future<SignupResult> signupCustomer({
    required String email,
    required String password,
    required String orgName,
    required String timezone,
    required bool tos,
    required bool privacy,
  });

  Future<void> verifyEmail({required String token, String? email});

  Future<List<CatalogLanguage>> fetchLanguages();

  Future<List<CatalogCertification>> fetchCertifications();

  Future<void> saveInterpreterProfile(InterpreterProfileInput input);

  Future<void> updateCustomerOrg(CustomerOrgInput input);

  Future<void> sendInvitation(TeamInviteInput input);
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => ApiOnboardingRepository(ref.watch(dioProvider)),
);

class ApiOnboardingRepository implements OnboardingRepository {
  ApiOnboardingRepository(this._dio);

  final Dio _dio;

  @override
  Future<SignupResult> signupPersonal({
    required String email,
    required String password,
    required bool tos,
    required bool privacy,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'account_type': 'personal',
        'email': email,
        'password': password,
        'consent': {'tos': tos, 'privacy': privacy},
      },
    );
    return _mapSignupResult(response.data!);
  }

  @override
  Future<SignupResult> signupCustomer({
    required String email,
    required String password,
    required String orgName,
    required String timezone,
    required bool tos,
    required bool privacy,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'account_type': 'business',
        'business_type': 'customer',
        'email': email,
        'password': password,
        'name': orgName,
        'timezone': timezone,
        'consent': {'tos': tos, 'privacy': privacy},
      },
    );
    return _mapSignupResult(response.data!);
  }

  @override
  Future<void> verifyEmail({required String token, String? email}) async {
    await _dio.post<void>('/auth/verify-email', data: {'token': token});
  }

  @override
  Future<List<CatalogLanguage>> fetchLanguages() async {
    final response = await _dio.get<List<dynamic>>('/catalog/languages');
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(
          (j) => CatalogLanguage(
            id: j['id'] as String,
            code: j['code'] as String,
            name: j['name'] as String,
            isSigned: j['is_signed'] as bool? ?? false,
          ),
        )
        .toList();
  }

  @override
  Future<List<CatalogCertification>> fetchCertifications() async {
    final response = await _dio.get<List<dynamic>>('/catalog/certifications');
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(
          (j) => CatalogCertification(
            id: j['id'] as String,
            name: j['name'] as String,
            issuer: j['issuer'] as String? ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<void> saveInterpreterProfile(InterpreterProfileInput input) async {
    await _dio.post<void>(
      '/interpreter-profiles/me',
      data: {
        'display_name': input.displayName,
        'timezone': input.timezone,
        'language_ids': input.languageIds,
        'certifications': input.certifications
            .map(
              (c) => {
                'certification_id': c.certificationId,
                'cert_number': c.certNumber,
                'expires_at': c.expiresAt?.toIso8601String(),
              },
            )
            .toList(),
      },
    );
  }

  @override
  Future<void> updateCustomerOrg(CustomerOrgInput input) async {
    await _dio.patch<void>(
      '/organizations/me',
      data: {
        'name': input.name,
        'industry_types': [input.industry],
        'registered_address': {'line1': input.registeredAddress},
      },
    );
  }

  @override
  Future<void> sendInvitation(TeamInviteInput input) async {
    await _dio.post<void>(
      '/invitations',
      data: {'email': input.email, 'role': input.role},
    );
  }

  SignupResult _mapSignupResult(Map<String, dynamic> data) {
    return SignupResult(
      userId: data['user_id'] as String,
      emailVerificationRequired:
          data['email_verification_required'] as bool? ?? true,
      organizationId: data['organization_id'] as String?,
      status: data['status'] as String?,
    );
  }
}
