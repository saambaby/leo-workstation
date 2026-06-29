// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MembershipImpl _$$MembershipImplFromJson(Map<String, dynamic> json) =>
    _$MembershipImpl(
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$MembershipImplToJson(_$MembershipImpl instance) =>
    <String, dynamic>{
      'tenantId': instance.tenantId,
      'tenantName': instance.tenantName,
      'role': instance.role,
    };
