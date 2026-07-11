import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_entities.freezed.dart';
part 'signup_entities.g.dart';

@freezed
class SignupResult with _$SignupResult {
  const factory SignupResult({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'email_verification_required')
    @Default(true)
    bool emailVerificationRequired,
    @JsonKey(name: 'organization_id') String? organizationId,
    String? status,
  }) = _SignupResult;

  factory SignupResult.fromJson(Map<String, dynamic> json) =>
      _$SignupResultFromJson(json);
}
