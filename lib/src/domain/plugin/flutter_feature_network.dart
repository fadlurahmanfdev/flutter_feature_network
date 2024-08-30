import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_network/src/data/dto/feature_network_exception.dart';
import 'package:flutter_feature_network/src/domain/interceptor/allowed_ssl_fingerprint_interceptor.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class FlutterFeatureNetwork {
  static Dio getDioClient({
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

    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }

    if (allowedFingerprints != null) {
      dio.interceptors.add(AllowedSSLFingerprintInterceptor(allowedSHAFingerprints: allowedFingerprints));
    }

    return dio;
  }

  static Future<bool> isConnectionSecure({
    required String serverUrl,
    required SHA sha,
    int timeout = 60,
    required List<String> allowedSHAFingerprints,
  }) async {
    try {
      await checkHttpCertificatePinning(
        serverUrl: serverUrl,
        sha: sha,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout,
      );
      return true;
    } on FeatureNetworkException catch (e) {
      log("failed checkHttpCertificatePinning: ${e.toJson()}");
      return false;
    } catch (e) {
      log("failed checkHttpCertificatePinning: $e");
      return false;
    }
  }

  static Future<void> checkHttpCertificatePinning({
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

  static Future<Uint8List> getCertificateBytesFromAsset({
    required String assetPath,
  }) async {
    return rootBundle.load(assetPath).then((byteData) {
      return byteData.buffer.asUint8List();
    });
  }
}
