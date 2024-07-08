import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true, genericArgumentFactories: true)
class BaseResponse<T> extends Equatable {
  final String? code;
  final String? message;
  final T? data;

  const BaseResponse({
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
        code,
        message,
        data,
      ];
}
