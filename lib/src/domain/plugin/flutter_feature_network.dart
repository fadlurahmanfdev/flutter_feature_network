import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_feature_network/src/data/dto/feature_network_exception.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class FlutterFeatureNetwork {
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
}
