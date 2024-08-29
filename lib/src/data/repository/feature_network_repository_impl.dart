import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_feature_network/src/data/repository/feature_network_repository.dart';
import 'package:flutter_feature_network/src/domain/interceptor/static_ssl_fingerprint_interceptor.dart';

class FeatureNetworkRepositoryImpl extends FeatureNetworkRepository {
  @override
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
  }) {
    assert(trustedCertificateBytes == null || allowedFingerprints == null);

    final dio = Dio(
      BaseOptions(
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        connectTimeout: connectTimeout,
        baseUrl: baseUrl,
        headers: headers,
      ),
    );

    if (trustedCertificateBytes != null) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final securityContext = SecurityContext();
        securityContext.setTrustedCertificatesBytes(trustedCertificateBytes);
        final httpClient = HttpClient(context: securityContext);
        return httpClient;
      };
    }

    if(allowedFingerprints != null){
      dio.interceptors.add(StaticSslFingerPrintInterceptor(allowedSHAFingerprints: allowedFingerprints));
    }

    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }

    return dio;
  }
}
