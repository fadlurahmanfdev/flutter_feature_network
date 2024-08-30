import 'package:dio/dio.dart';
import 'package:flutter_feature_network/src/data/dto/feature_network_exception.dart';
import 'package:flutter_feature_network/src/domain/plugin/flutter_feature_network.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:logger/logger.dart';

class AllowedSSLFingerprintInterceptor extends InterceptorsWrapper {
  List<String> allowedSHAFingerprints;

  AllowedSSLFingerprintInterceptor({required this.allowedSHAFingerprints});

  final Logger _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var baseUrl = options.baseUrl;

    if (options.path.contains('http') || options.baseUrl.isEmpty) {
      baseUrl = options.path;
    }

    try {
      await FlutterFeatureNetwork.checkHttpCertificatePinning(
        serverUrl: baseUrl,
        sha: SHA.SHA256,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: 60,
      );
      handler.next(options);
    } on FeatureNetworkException catch (e) {
      String loggerText = "Feature-Network-Exception";
      loggerText += "\nCODE: ${e.code}";
      loggerText += "\nMESSAGE: ${e.message}";
      _logger.e(loggerText);
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
