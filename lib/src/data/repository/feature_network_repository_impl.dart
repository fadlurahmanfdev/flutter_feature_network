import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_network/src/data/dto/feature_network_exception.dart';
import 'package:flutter_feature_network/src/data/repository/feature_network_repository.dart';
import 'package:flutter_feature_network/src/domain/interceptor/allowed_ssl_fingerprint_interceptor.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class FeatureNetworkRepositoryImpl extends FeatureNetworkRepository {
  @override
  Dio getDioClient({
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Duration? connectTimeout,
    String baseUrl = '',
    Map<String, dynamic>? headers,
    List<Interceptor>? interceptors,
    List<int>? trustedCertificateBytes,
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

    if (allowedFingerprints != null) {
      dio.interceptors.add(AllowedSSLFingerprintInterceptor(allowedSHAFingerprints: allowedFingerprints));
    }

    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }

    return dio;
  }

  @override
  Future<bool> isConnectionSecure({
    required String serverUrl,
    required SHA sha,
    int timeout = 60,
    required List<String> allowedSHAFingerprints,
  }) async {
    try {
      await checkIsConnectionSecure(
        serverUrl: serverUrl,
        sha: sha,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout,
      );
      return true;
    } on FeatureNetworkException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> checkIsConnectionSecure({
    required String serverUrl,
    required SHA sha,
    int timeout = 60,
    required List<String> allowedSHAFingerprints,
  }) async {
    try {
      final connection = await HttpCertificatePinning.check(
        serverURL: serverUrl,
        sha: sha,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout,
      );
      if (!connection.contains('CONNECTION_SECURE')) {
        throw FeatureNetworkException(
          code: 'CONNECTION_NOT_SECURE',
          message: 'Connection not secure: $connection',
        );
      }
    } on PlatformException catch (e) {
      throw FeatureNetworkException(
        code: 'BAD_CERTIFICATE',
        message: 'Bad Certificate: $e',
      );
    }
  }
}
