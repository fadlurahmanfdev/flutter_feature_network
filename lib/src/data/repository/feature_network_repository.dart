import 'package:dio/dio.dart';

abstract class FeatureNetworkRepository {
  Dio getDio({
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Duration? connectTimeout,
    String baseUrl = '',
    Map<String, dynamic>? headers,
    List<Interceptor>? interceptors,
    List<int>? trustedCertificateBytes,
  });
}
