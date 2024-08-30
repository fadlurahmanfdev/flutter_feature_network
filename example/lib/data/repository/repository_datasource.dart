import 'dart:developer';

import 'package:example/data/dto/model/feature_exception.dart';
import 'package:example/data/dto/response/post/post_response.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';

abstract class RepositoryDatasource {
  Future<PostResponse> getPostById({required int id});

  Future<PostResponse> getPostByIdCorrectFingerprint({required int id});

  Future<PostResponse> getPostByIdIncorrectFingerprint({required int id});

  Future<PostResponse> getPostByIdDynamicFingerprint({required int id});
}

class RepositoryDatasourceImpl extends RepositoryDatasource {
  Dio placeHolderStandardDio;
  Dio placeHolderCorrectFingerprintDio;
  Dio placeHolderIncorrectFingerprintDio;
  Dio placeHolderDynamicFingerprintDio;

  RepositoryDatasourceImpl({
    required this.placeHolderStandardDio,
    required this.placeHolderCorrectFingerprintDio,
    required this.placeHolderIncorrectFingerprintDio,
    required this.placeHolderDynamicFingerprintDio,
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
      throw FeatureException(title: 'Failed DIO', desc: '${e.response?.statusCode} - ${e.type} - ${e.message}');
    } catch (e) {
      throw FeatureException(title: 'Failed', desc: 'error: $e');
    }
  }

  @override
  Future<PostResponse> getPostByIdCorrectFingerprint({required int id}) async {
    try {
      final res = await placeHolderCorrectFingerprintDio.get(
        'posts/$id',
      );
      final dataMap = res.data as Map<String, dynamic>? ?? {};
      return PostResponse.fromJson(dataMap);
    } on DioException catch (e) {
      throw FeatureException(title: 'Failed DIO', desc: '${e.response?.statusCode} - ${e.type} - ${e.message}');
    } catch (e) {
      throw FeatureException(title: 'Failed', desc: 'error: $e');
    }
  }

  @override
  Future<PostResponse> getPostByIdIncorrectFingerprint({required int id}) async {
    try {
      final res = await placeHolderIncorrectFingerprintDio.get(
        'posts/$id',
      );
      final dataMap = res.data as Map<String, dynamic>? ?? {};
      return PostResponse.fromJson(dataMap);
    } on DioException catch (e) {
      throw FeatureException(title: 'Failed DIO', desc: '${e.response?.statusCode} - ${e.type} - ${e.message}');
    } catch (e) {
      throw FeatureException(title: 'Failed', desc: 'error: $e');
    }
  }

  @override
  Future<PostResponse> getPostByIdDynamicFingerprint({required int id}) async {
    try {
      final res = await placeHolderDynamicFingerprintDio.get(
        'posts/$id',
      );
      final dataMap = res.data as Map<String, dynamic>? ?? {};
      return PostResponse.fromJson(dataMap);
    } on DioException catch (e) {
      throw FeatureException(title: 'Failed DIO', desc: '${e.response?.statusCode} - ${e.type} - ${e.message}');
    } catch (e) {
      throw FeatureException(title: 'Failed', desc: 'error: $e');
    }
  }
}
