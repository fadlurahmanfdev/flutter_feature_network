import 'package:example/data/dto/model/feature_exception.dart';
import 'package:example/data/dto/response/post/post_response.dart';
import 'package:dio/dio.dart';

abstract class RepositoryDatasource {
  Future<PostResponse> getPostById({required int id});

  Future<PostResponse> getPostByIdCorrectFingerprint({required int id});

  Future<PostResponse> getPostByIdIncorrectFingerprint({required int id});

  Future<PostResponse> getPostByIdConfigurableFingerprint({required int id});

  Future<PostResponse> getPostByIdCorrectCertByte({required int id});

  Future<PostResponse> getPostByIdIncorrectCertByte({required int id});

  Future<PostResponse> getPostByIdDownloadableCertByte({required int id});
}

class RepositoryDatasourceImpl extends RepositoryDatasource {
  Dio placeHolderStandardDio;
  Dio placeHolderCorrectFingerprintDio;
  Dio placeHolderIncorrectFingerprintDio;
  Dio placeHolderConfigurableFingerprintDio;
  Dio placeHolderCorrectCertByteDio;
  Dio placeHolderIncorrectCertByteDio;
  Dio placeHolderDownloadableCertByteDio;

  RepositoryDatasourceImpl({
    required this.placeHolderStandardDio,
    required this.placeHolderCorrectFingerprintDio,
    required this.placeHolderIncorrectFingerprintDio,
    required this.placeHolderConfigurableFingerprintDio,
    required this.placeHolderCorrectCertByteDio,
    required this.placeHolderIncorrectCertByteDio,
    required this.placeHolderDownloadableCertByteDio,
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
      throw FeatureException(title: 'Failed GENERAL', desc: 'error: $e');
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
  Future<PostResponse> getPostByIdConfigurableFingerprint({required int id}) async {
    try {
      final res = await placeHolderConfigurableFingerprintDio.get(
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
  Future<PostResponse> getPostByIdCorrectCertByte({required int id}) async {
    try {
      final res = await placeHolderCorrectCertByteDio.get(
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
  Future<PostResponse> getPostByIdIncorrectCertByte({required int id}) async {
    try {
      final res = await placeHolderIncorrectCertByteDio.get(
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
  Future<PostResponse> getPostByIdDownloadableCertByte({required int id}) async {
    try {
      final res = await placeHolderDownloadableCertByteDio.get(
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
