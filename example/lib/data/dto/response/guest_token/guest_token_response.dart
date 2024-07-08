import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'guest_token_response.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GuestTokenResponse extends Equatable {
  final String? accessToken;
  final int? expiresIn;

  const GuestTokenResponse({
    this.accessToken,
    this.expiresIn,
  });

  factory GuestTokenResponse.fromJson(Map<String, dynamic> json) => _$GuestTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GuestTokenResponseToJson(this);

  String serialize() => jsonEncode(toJson());

  static GuestTokenResponse? deserialize(String? value) =>
      value == null ? null : GuestTokenResponse.fromJson(jsonDecode(value));

  @override
  List<Object?> get props => [
        accessToken,
        expiresIn,
      ];
}
