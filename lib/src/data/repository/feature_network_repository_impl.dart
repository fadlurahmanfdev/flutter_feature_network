import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:networx/src/data/repository/feature_network_repository.dart';
import 'package:networx/src/feature_network.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

@Deprecated('Deprecated in v1.x.x, removed in v2.x.x.')
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
  }) =>
      FeatureNetwork.getDioClient(
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        connectTimeout: connectTimeout,
        baseUrl: baseUrl,
        headers: headers,
        interceptors: interceptors,
        trustedCertificateBytes: trustedCertificateBytes,
        allowedFingerprints: allowedFingerprints,
      );

  @override
  Future<bool> isConnectionSecure({
    required String serverUrl,
    required SHA sha,
    int timeout = 60,
    required List<String> allowedSHAFingerprints,
  }) =>
      FeatureNetwork.isConnectionSecure(
        serverUrl: serverUrl,
        sha: sha,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout,
      );

  @override
  Future<void> checkHttpCertificatePinning({
    required String serverUrl,
    required SHA sha,
    int timeout = 60,
    required List<String> allowedSHAFingerprints,
  }) =>
      FeatureNetwork.checkHttpCertificatePinning(
        serverUrl: serverUrl,
        sha: sha,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout,
      );

  @override
  Future<Uint8List> getCertificateBytesFromAsset({required String assetPath}) =>
      FeatureNetwork.getCertificateBytesFromAsset(assetPath: assetPath);
}
