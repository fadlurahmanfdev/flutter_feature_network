import 'package:dio/dio.dart';
import 'package:example/data/dto/model/example_feature.dart';
import 'package:example/data/dto/model/feature_exception.dart';
import 'package:example/data/dto/response/post/post_response.dart';

abstract class RepositoryDatasource {
  Future<PostResponse> fetchPost(ExampleFeature feature);
}

class RepositoryDatasourceImpl extends RepositoryDatasource {
  final Dio fetchOkDio;
  final Dio correctCertificateHashDio;
  final Dio incorrectCertificateHashDio;
  final Dio correctSpkiHashDio;
  final Dio incorrectSpkiHashDio;
  final Dio correctCertBytesDio;
  final Dio incorrectCertBytesDio;
  final Dio burpSuiteDio;

  RepositoryDatasourceImpl({
    required this.fetchOkDio,
    required this.correctCertificateHashDio,
    required this.incorrectCertificateHashDio,
    required this.correctSpkiHashDio,
    required this.incorrectSpkiHashDio,
    required this.correctCertBytesDio,
    required this.incorrectCertBytesDio,
    required this.burpSuiteDio,
  });

  @override
  Future<PostResponse> fetchPost(ExampleFeature feature) {
    return _getPost(_dioFor(feature));
  }

  Dio _dioFor(ExampleFeature feature) {
    switch (feature) {
      case ExampleFeature.fetchOk:
        return fetchOkDio;
      case ExampleFeature.correctCertificateHash:
        return correctCertificateHashDio;
      case ExampleFeature.incorrectCertificateHash:
        return incorrectCertificateHashDio;
      case ExampleFeature.correctSpkiHash:
        return correctSpkiHashDio;
      case ExampleFeature.incorrectSpkiHash:
        return incorrectSpkiHashDio;
      case ExampleFeature.correctCertBytes:
        return correctCertBytesDio;
      case ExampleFeature.incorrectCertBytes:
        return incorrectCertBytesDio;
      case ExampleFeature.burpSuite:
        return burpSuiteDio;
    }
  }

  Future<PostResponse> _getPost(Dio dio) async {
    try {
      final res = await dio.get('posts/1');
      final dataMap = res.data as Map<String, dynamic>? ?? {};
      return PostResponse.fromJson(dataMap);
    } on DioException catch (e) {
      throw FeatureException(
        title: 'Request failed',
        desc: '${e.type} — ${e.message ?? e.error}',
      );
    } catch (e) {
      throw FeatureException(title: 'Request failed', desc: '$e');
    }
  }
}
