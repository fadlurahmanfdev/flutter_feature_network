class FeatureNetworkException {
  final String code;
  final String message;

  FeatureNetworkException({
    required this.code,
    required this.message,
  });

  Map<String, String> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
