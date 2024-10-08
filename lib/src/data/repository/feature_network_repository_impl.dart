import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_feature_network/src/data/repository/feature_network_repository.dart';
import 'package:flutter_feature_network/src/domain/plugin/flutter_feature_network.dart';
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
  }) =>
      FlutterFeatureNetwork.getDioClient(
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
      FlutterFeatureNetwork.isConnectionSecure(
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
      FlutterFeatureNetwork.checkHttpCertificatePinning(
        serverUrl: serverUrl,
        sha: sha,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout,
      );

  @override
  Future<Uint8List> getCertificateBytesFromAsset({required String assetPath}) =>
      FlutterFeatureNetwork.getCertificateBytesFromAsset(assetPath: assetPath);
}
