import 'dart:developer';

import 'package:example/data/dto/model/feature_exception.dart';
import 'package:example/data/dto/response/post/post_response.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';

abstract class RepositoryDatasource {
  Future<PostResponse> getPostById({required int id});
}

class RepositoryDatasourceImpl extends RepositoryDatasource {
  Dio placeHolderStandardDio;
  Dio sslDio;

  RepositoryDatasourceImpl({
    required this.placeHolderStandardDio,
    required this.sslDio,
  });

  @override
  Future<PostResponse> getPostById({required int id}) async {
    try {
      final res = await placeHolderStandardDio.get(
        'posts/$id',
      );
      final dataMap = res.data as Map<String, dynamic>? ?? {};
      return PostResponse.fromJson(dataMap);
    } on DioException catch (e) {
      log("failed dio: $e");
      throw FeatureException(title: 'Failed DIO', desc: '${e.response?.statusCode} - ${e.type} - ${e.message}');
    } catch (e) {
      throw FeatureException(title: 'Failed', desc: 'error: $e');
    }
  }
}
