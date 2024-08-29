import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class StaticSslFingerPrintInterceptor extends InterceptorsWrapper {
  List<String> allowedSHAFingerprints;

  StaticSslFingerPrintInterceptor({required this.allowedSHAFingerprints});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var baseUrl = options.baseUrl;

    if (options.path.contains('http') || options.baseUrl.isEmpty) {
      baseUrl = options.path;
    }

    try {
      final secure = await HttpCertificatePinning.check(
        serverURL: baseUrl,
        headerHttp: {},
        sha: SHA.SHA256,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: 60,
      );
      if (secure.contains('CONNECTION_SECURE')) {
        handler.next(options);
      } else {
        throw HandshakeException('Connection not secure: $secure');
      }
    } on PlatformException catch (e) {
      throw HandshakeException('Platform Exception Bad Certificate: ${e.message}');
    }
  }
}
