import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

abstract class FeatureNetworkRepository {
  Dio getDioClient({
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Duration? connectTimeout,
    String baseUrl = '',
    Map<String, dynamic>? headers,
    List<Interceptor>? interceptors,
    /**
     * static certificate bytes, meaning if user already inside the app,
     * and the certificate is not valid anymore, the user still can use the app
     *
     * only one of trustedCertificateBytes or allowedFingerprints can be used.
     * */
    List<int>? trustedCertificateBytes,
    /**
     * static fingerprints, meaning if user already inside the app,
     * and the certificate is not valid anymore, the user still can use the app
     *
     * only one of trustedCertificateBytes or allowedFingerprints can be used.
     * */
    List<String>? allowedFingerprints,
  });

  Future<bool> isConnectionSecure({
    required String serverUrl,
    required SHA sha,
    int timeout = 60,
    required List<String> allowedSHAFingerprints,
  });

  Future<void> checkIsConnectionSecure({
    required String serverUrl,
    required SHA sha,
    int timeout = 60,
    required List<String> allowedSHAFingerprints,
  });
}
