class FeatureException implements Exception {
  final String title;
  final String desc;

  FeatureException({
    required this.title,
    required this.desc,
  });
}
