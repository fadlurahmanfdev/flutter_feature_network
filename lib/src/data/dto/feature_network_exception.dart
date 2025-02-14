@Deprecated('Deprecated in v1.x.x, removed in v2.x.x. Replace with NetworxException')
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
