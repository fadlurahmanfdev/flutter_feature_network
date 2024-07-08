import 'package:equatable/equatable.dart';
import 'package:example/data/dto/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_bebas_response.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true, genericArgumentFactories: true)
class BaseBebasResponse<T> extends BaseResponse<T> with EquatableMixin {
  final bool? status;

  const BaseBebasResponse({this.status, super.message, super.data});

  factory BaseBebasResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseBebasResponseFromJson(json, fromJsonT);

  @override
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$BaseBebasResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}
