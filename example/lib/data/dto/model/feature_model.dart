import 'package:example/data/dto/model/example_feature.dart';

class FeatureModel {
  final ExampleFeature feature;
  final String title;
  final String message;

  const FeatureModel({
    required this.feature,
    required this.title,
    required this.message,
  });

  factory FeatureModel.from(ExampleFeature feature) {
    return FeatureModel(
      feature: feature,
      title: feature.title,
      message: feature.message,
    );
  }
}
