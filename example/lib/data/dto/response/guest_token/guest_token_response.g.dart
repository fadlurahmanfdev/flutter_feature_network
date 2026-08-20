// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestTokenResponse _$GuestTokenResponseFromJson(Map json) => GuestTokenResponse(
  accessToken: json['accessToken'] as String?,
  expiresIn: (json['expiresIn'] as num?)?.toInt(),
);

Map<String, dynamic> _$GuestTokenResponseToJson(GuestTokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expiresIn': instance.expiresIn,
    };
