import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true, genericArgumentFactories: true)
class BaseResponse<T> extends Equatable {
  @JsonKey(name: 'status')
  final bool? status;
  @JsonKey(name: 'code')
  final String? code;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'data')
  final T? data;

  const BaseResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$BaseResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [
        status,
        code,
        message,
        data,
      ];
}
