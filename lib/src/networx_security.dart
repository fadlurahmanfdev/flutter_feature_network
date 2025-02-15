import 'package:flutter/services.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:networx/src/constant/exception_constant.dart';
import 'package:networx/src/exception/networx_exception.dart';

class NetworxSecurity {
  /// Check whether the connection secure by compare fingerprint & url http of current
  /// - [serverUrl] - which url want to checked
  /// - [sha] - type of SHA fingerprint,
  /// - [allowedSHAFingerprints] - SHA fingerprints that will be check with [serverUrl]
  /// - [timeout] - how long it take to stop process.
  static Future<bool> isConnectionSecure({
    required String serverUrl,
    Map<String, String>? headerHttp,
    required SHA sha,
    required List<String> allowedSHAFingerprints,
    required int timeout,
  }) async {
    try {
      final connection = await HttpCertificatePinning.check(
        serverURL: serverUrl,
        headerHttp: headerHttp,
        sha: sha,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout,
      );
      if (connection.contains('CONNECTION_SECURE')) {
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      throw NetworxException(code: ExceptionConstant.BAD_FINGERPRINT.code, message: e.message);
    }
  }
}
