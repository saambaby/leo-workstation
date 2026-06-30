import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/onboarding_models.dart';
import 'mock_onboarding_store.dart';

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

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useMocks) {
    return MockOnboardingRepository();
  }
  return ApiOnboardingRepository(ref.watch(dioProvider));
});

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

class MockOnboardingRepository implements OnboardingRepository {
  final _store = MockOnboardingStore.instance;

  static const _mockLanguages = [
    CatalogLanguage(id: '1', code: 'es', name: 'Spanish', isSigned: false),
    CatalogLanguage(id: '2', code: 'en', name: 'English', isSigned: false),
    CatalogLanguage(id: '3', code: 'ase', name: 'ASL', isSigned: true),
    CatalogLanguage(id: '4', code: 'zh', name: 'Mandarin', isSigned: false),
  ];

  static const _mockCerts = [
    CatalogCertification(id: 'c1', name: 'Medical', issuer: 'CCHI'),
    CatalogCertification(id: 'c2', name: 'Interpreting', issuer: 'RID'),
  ];

  @override
  Future<SignupResult> signupPersonal({
    required String email,
    required String password,
    required bool tos,
    required bool privacy,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!tos || !privacy) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/signup'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/signup'),
          statusCode: 400,
        ),
      );
    }
    if (_store.lookup(email) != null) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/signup'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/signup'),
          statusCode: 409,
        ),
      );
    }
    _store.registerSignup(email: email, path: SignupPath.personal);
    return const SignupResult(
      userId: 'mock-user-personal',
      emailVerificationRequired: true,
      organizationId: null,
      status: null,
    );
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
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!tos || !privacy) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/signup'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/signup'),
          statusCode: 400,
        ),
      );
    }
    if (_store.lookup(email) != null) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/signup'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/signup'),
          statusCode: 409,
        ),
      );
    }
    _store.registerSignup(
      email: email,
      path: SignupPath.customer,
      orgName: orgName,
      timezone: timezone,
    );
    return const SignupResult(
      userId: 'mock-user-customer',
      emailVerificationRequired: true,
      organizationId: '33333333-3333-3333-3333-333333333333',
      status: 'active',
    );
  }

  @override
  Future<void> verifyEmail({required String token, String? email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (token != '123456') {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/verify-email'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/verify-email'),
          statusCode: 400,
        ),
      );
    }
    if (email != null) {
      _store.markVerified(email);
    } else {
      _store.markVerifiedByToken();
    }
  }

  @override
  Future<List<CatalogLanguage>> fetchLanguages() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _mockLanguages;
  }

  @override
  Future<List<CatalogCertification>> fetchCertifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _mockCerts;
  }

  @override
  Future<void> saveInterpreterProfile(InterpreterProfileInput input) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> updateCustomerOrg(CustomerOrgInput input) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> sendInvitation(TeamInviteInput input) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!input.email.contains('@')) {
      throw DioException(
        requestOptions: RequestOptions(path: '/invitations'),
        response: Response(
          requestOptions: RequestOptions(path: '/invitations'),
          statusCode: 400,
        ),
      );
    }
  }
}
