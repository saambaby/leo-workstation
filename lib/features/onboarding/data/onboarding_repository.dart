import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/onboarding_entities.dart';
import 'dto/onboarding_dto.dart';

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
      data: SignupPersonalRequestDto(
        email: email,
        password: password,
        consent: ConsentDto(tos: tos, privacy: privacy),
      ).toJson(),
    );
    return SignupResult.fromJson(response.data!);
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
      data: SignupCustomerRequestDto(
        email: email,
        password: password,
        name: orgName,
        timezone: timezone,
        consent: ConsentDto(tos: tos, privacy: privacy),
      ).toJson(),
    );
    return SignupResult.fromJson(response.data!);
  }

  @override
  Future<void> verifyEmail({required String token, String? email}) async {
    await _dio.post<void>(
      '/auth/verify-email',
      data: VerifyEmailRequestDto(token: token).toJson(),
    );
  }

  @override
  Future<List<CatalogLanguage>> fetchLanguages() async {
    final response = await _dio.get<List<dynamic>>('/catalog/languages');
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(CatalogLanguage.fromJson)
        .toList();
  }

  @override
  Future<List<CatalogCertification>> fetchCertifications() async {
    final response = await _dio.get<List<dynamic>>('/catalog/certifications');
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(CatalogCertification.fromJson)
        .toList();
  }

  @override
  Future<void> saveInterpreterProfile(InterpreterProfileInput input) async {
    await _dio.post<void>(
      '/interpreter-profiles/me',
      data: InterpreterProfileRequestDto.fromInput(input).toJson(),
    );
  }

  @override
  Future<void> updateCustomerOrg(CustomerOrgInput input) async {
    await _dio.patch<void>(
      '/organizations/me',
      data: CustomerOrgRequestDto.fromInput(input).toJson(),
    );
  }

  @override
  Future<void> sendInvitation(TeamInviteInput input) async {
    await _dio.post<void>(
      '/invitations',
      data: TeamInviteRequestDto.fromInput(input).toJson(),
    );
  }
}
