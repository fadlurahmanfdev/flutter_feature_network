// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssl_fingerprint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SslFingerprintModel _$SslFingerprintModelFromJson(Map json) =>
    SslFingerprintModel(
      fingerprints: (json['fingerprints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SslFingerprintModelToJson(
  SslFingerprintModel instance,
) => <String, dynamic>{'fingerprints': instance.fingerprints};
