import 'package:dio/dio.dart';
import 'package:networx/src/data/dto/feature_network_exception.dart';
import 'package:networx/src/feature_network.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:logger/logger.dart';

@Deprecated('Deprecated in v1.x.x, removed in v2.x.x. Replace with NetworxCertificatePinningInterceptor')
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
      await FeatureNetwork.checkHttpCertificatePinning(
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
