import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_response.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/onboarding_entities.dart';
import 'dto/onboarding_dto.dart';

abstract class OnboardingRepository {
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
  Future<List<CatalogLanguage>> fetchLanguages() async {
    const endpoint = '/catalog/languages';
    final response = await _dio.get<List<dynamic>>(endpoint);
    return requireJsonList(response, endpoint: endpoint)
        .cast<Map<String, dynamic>>()
        .map(CatalogLanguage.fromJson)
        .toList();
  }

  @override
  Future<List<CatalogCertification>> fetchCertifications() async {
    const endpoint = '/catalog/certifications';
    final response = await _dio.get<List<dynamic>>(endpoint);
    return requireJsonList(response, endpoint: endpoint)
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
