import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:networx/src/constant/exception_constant.dart';
import 'package:networx/src/exception/networx_exception.dart';
import 'package:networx/src/networx_security.dart';

/// Interceptor for checking whether the SHA Fingerprint is valid with URL HTTP Certificate
/// - [allowedSHAFingerprints] - list of fingerprint will checked with url http certificate url
/// - [timeout] - timeout in second to check certificate
class NetworxCertificatePinningInterceptor extends InterceptorsWrapper {
  List<String> allowedSHAFingerprints;
  int? timeout;

  NetworxCertificatePinningInterceptor({
    required this.allowedSHAFingerprints,
    this.timeout,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var baseUrl = options.baseUrl;

    if (options.path.contains('http') || options.baseUrl.isEmpty) {
      baseUrl = options.path;
    }

    try {
      log("start process if connection secure", level: 300);
      bool isConnectionSecure = await NetworxSecurity.isConnectionSecure(
        serverUrl: baseUrl,
        sha: SHA.SHA256,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: timeout ?? 60,
      );
      if (isConnectionSecure) {
        log("connection secure", level: 300);
        handler.next(options);
        return;
      }

      log("connection not secure", level: 800);
      onConnectionNotSecure(options, handler);
    } on NetworxException catch (e) {
      log("failed to check whether connection not secure -> code: ${e.code}, detail: ${e.message}", level: 800);
      if (e.code == ExceptionConstant.BAD_FINGERPRINT.code) {
        onBadFingerPrint(options, handler, e);
      } else {
        onOtherException(options, handler, e);
      }
    } catch (e) {
      onOtherException(options, handler, e);
    }
  }

  /// triggered when SHA Fingerprint is not valid with URL HTTP Certificate.
  void onConnectionNotSecure(RequestOptions options, RequestInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badCertificate,
        error: ExceptionConstant.FINGERPRINT_CERTIFICATE_NOT_VALID.toJson(),
      ),
      true,
    );
  }

  /// triggered when bad SHA Fingerprint is detected.
  void onBadFingerPrint(RequestOptions options, RequestInterceptorHandler handler, NetworxException exception) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badCertificate,
        error: exception.toJson(),
      ),
      true,
    );
  }

  /// triggered when other exception happened.
  void onOtherException(RequestOptions options, RequestInterceptorHandler handler, Object e) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.unknown,
        error: e,
      ),
      true,
    );
  }
}
