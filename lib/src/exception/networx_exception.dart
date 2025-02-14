import 'dart:core';

class NetworxException implements Exception {
  final String code;
  String? message;

  NetworxException({
    required this.code,
    this.message,
  });

  Map<String, String?> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
