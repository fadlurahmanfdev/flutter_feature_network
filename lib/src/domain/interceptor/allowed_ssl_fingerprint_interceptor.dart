import 'package:dio/dio.dart';
import 'package:flutter_feature_network/src/data/dto/feature_network_exception.dart';
import 'package:flutter_feature_network/src/data/repository/feature_network_repository.dart';
import 'package:flutter_feature_network/src/data/repository/feature_network_repository_impl.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class AllowedSSLFingerprintInterceptor extends InterceptorsWrapper {
  List<String> allowedSHAFingerprints;

  AllowedSSLFingerprintInterceptor({required this.allowedSHAFingerprints}) {
    _featureNetworkRepository = FeatureNetworkRepositoryImpl();
  }

  FeatureNetworkRepository? _featureNetworkRepository;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var baseUrl = options.baseUrl;

    if (options.path.contains('http') || options.baseUrl.isEmpty) {
      baseUrl = options.path;
    }

    try {
      await _featureNetworkRepository?.checkIsConnectionSecure(
        serverUrl: baseUrl,
        sha: SHA.SHA256,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: 60,
      );
      handler.next(options);
    } on FeatureNetworkException catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
          error: e.message,
          response: Response(
            requestOptions: options,
            statusCode: 495,
          ),
        ),
      );
    }
  }
}
