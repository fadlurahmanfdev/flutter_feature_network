import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ssl_fingerprint_model.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class SslFingerprintModel extends Equatable {
  final List<String>? fingerprints;

  const SslFingerprintModel({
    this.fingerprints,
  });

  factory SslFingerprintModel.fromJson(Map<String, dynamic> json) => _$SslFingerprintModelFromJson(json);

  Map<String, dynamic> toJson() => _$SslFingerprintModelToJson(this);

  String serialize() => jsonEncode(toJson());

  static SslFingerprintModel? deserialize(String? value) =>
      value == null ? null : SslFingerprintModel.fromJson(jsonDecode(value));

  @override
  List<Object?> get props => [
        fingerprints,
      ];
}
