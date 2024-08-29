import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_response.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PostResponse extends Equatable {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  const PostResponse({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostResponseToJson(this);

  String serialize() => jsonEncode(toJson());

  static PostResponse? deserialize(String? value) => value == null ? null : PostResponse.fromJson(jsonDecode(value));

  @override
  List<Object?> get props => [
        userId,
        id,
        title,
        body,
      ];
}
