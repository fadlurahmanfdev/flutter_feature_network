import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:networx/src/interceptor/networx_certificate_pinning_interceptor.dart';
import 'package:networx/src/interceptor/networx_handshake_ssl_interceptor.dart';

class NetworxDio {
  /// Generate Dio Client with SSL Security feature.
  ///
  /// [trustedCertificateBytes] cannot be used with [allowedFingerprints], only one of them can be used.
  ///
  /// The interceptor will checked by order, if the first interceptor error or thrown an error, the next interceptor will not be called.
  ///
  /// [allowedFingerprints] cannot be used with [customCertificatePinningInterceptor], only one of them can be used.
  ///
  /// - [dio] - The dio client that will add ssl feature
  /// - [prefixInterceptors] - The interceptors added in the first section before the other interceptor.
  /// - [suffixInterceptors] - The interceptors added in the last section after all the other interceptor.
  /// - [trustedCertificateBytes] - The pem certificate for ssl checking in bytes type.
  /// - [customHandshakeSSLInterceptor] - Custom interceptor for pem certificate checking.
  /// - [allowedFingerprints] - The fingerprints that will checked with URL HTTP Certificate.
  /// - [customCertificatePinningInterceptor] - Custom interceptor for check http certificate pinning.
  static Dio getClient({
    required Dio dio,
    List<Interceptor>? prefixInterceptors,
    List<Interceptor>? suffixInterceptors,
    List<int>? trustedCertificateBytes,
    NetworxHandshakeSSLInterceptor? customHandshakeSSLInterceptor,
    List<String>? allowedFingerprints,
    NetworxCertificatePinningInterceptor? customCertificatePinningInterceptor,
  }) {
    assert(trustedCertificateBytes == null || allowedFingerprints == null);
    assert(allowedFingerprints == null || customCertificatePinningInterceptor == null);

    if (prefixInterceptors != null) {
      dio.interceptors.addAll(prefixInterceptors);
    }

    if (trustedCertificateBytes != null) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final securityContext = SecurityContext();
        securityContext.setTrustedCertificatesBytes(trustedCertificateBytes);
        final httpClient = HttpClient(context: securityContext);
        return httpClient;
      };
      dio.interceptors.add(NetworxHandshakeSSLInterceptor());
    }

    if (customCertificatePinningInterceptor != null) {
      dio.interceptors.add(customCertificatePinningInterceptor);
    } else if (allowedFingerprints != null) {
      dio.interceptors.add(NetworxCertificatePinningInterceptor(allowedSHAFingerprints: allowedFingerprints));
    }

    if (suffixInterceptors != null) {
      dio.interceptors.addAll(suffixInterceptors);
    }

    return dio;
  }
}
