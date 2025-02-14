import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:example/data/dto/model/ssl_fingerprint_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:dio/dio.dart';
import 'package:networx/flutter_feature_network.dart';

class ConfigurableSSLInterceptor extends InterceptorsWrapper {
  FirebaseRemoteConfig remoteConfig;

  ConfigurableSSLInterceptor({required this.remoteConfig});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var baseUrl = options.baseUrl;

    if (options.path.contains('http') || options.baseUrl.isEmpty) {
      baseUrl = options.path;
    }

    try {
      await remoteConfig.fetchAndActivate();
      final jsonStringValue = remoteConfig.getString('SSL_FINGERPRINT');
      final jsonValue = json.decode(jsonStringValue);
      final SslFingerprintModel sslFingerprintModel = SslFingerprintModel.fromJson(jsonValue as Map<String, dynamic>);
      log("SSL inside remote config: $sslFingerprintModel");
      final isSecure = await NetworxSecurity.isConnectionSecure(
        serverUrl: baseUrl,
        sha: SHA.SHA256,
        allowedSHAFingerprints: sslFingerprintModel.fingerprints ?? [],
        timeout: 60,
      );
      if (isSecure) {
        handler.next(options);
      } else {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badCertificate,
            error: const HandshakeException('Connection is not secure'),
            response: Response(
              requestOptions: options,
              statusCode: 495,
            ),
          ),
        );
      }
    } on NetworxException catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
          error: e,
          response: Response(
            requestOptions: options,
            statusCode: 495,
          ),
        ),
      );
    } catch (e) {
      handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.unknown,
        error: e,
      ),);
    }
  }
}
