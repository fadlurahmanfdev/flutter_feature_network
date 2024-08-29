import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:example/data/dto/model/ssl_fingerprint_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class DynamicSslInterceptor extends SSLInterceptor {
  FirebaseRemoteConfig remoteConfig;

  DynamicSslInterceptor({required this.remoteConfig});

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
      log("ssl model: $sslFingerprintModel");
      final secure = await HttpCertificatePinning.check(
        serverURL: baseUrl,
        headerHttp: {},
        sha: SHA.SHA256,
        allowedSHAFingerprints: sslFingerprintModel.fingerprints ?? [],
        timeout: 60,
      );
      if (secure.contains('CONNECTION_SECURE')) {
        handler.next(options);
      } else {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badCertificate,
            error: HandshakeException('Connection is not secure: $secure'),
            response: Response(
              requestOptions: options,
              statusCode: 495,
            ),
          ),
        );
      }
    } on PlatformException catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
          error: HandshakeException('Connection is not secure: $e'),
          response: Response(
            requestOptions: options,
            statusCode: 495,
          ),
        ),
      );
    } catch (e) {
      handler.next(options);
    }
  }

  @override
  void onHandshakeException(DioException dioException, ErrorInterceptorHandler handler) async {
    try {} catch (e) {
      handler.next(dioException);
    }
  }
}
