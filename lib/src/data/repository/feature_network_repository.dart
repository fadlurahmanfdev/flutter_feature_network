import 'package:dio/dio.dart';

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
}
