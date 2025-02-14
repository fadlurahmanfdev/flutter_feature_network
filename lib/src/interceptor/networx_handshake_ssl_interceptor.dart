import 'dart:io';

import 'package:dio/dio.dart';

class NetworxHandshakeSSLInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is HandshakeException) {
      onHandshakeException(err, handler);
    } else {
      super.onError(err, handler);
    }
  }

  void onHandshakeException(DioException dioException, ErrorInterceptorHandler handler){
    handler.reject(
      DioException(
        requestOptions: dioException.requestOptions,
        type: DioExceptionType.badCertificate,
        error: dioException.error,
      ),
    );
  }
}
