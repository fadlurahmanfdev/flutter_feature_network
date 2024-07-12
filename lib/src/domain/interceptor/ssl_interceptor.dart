import 'dart:io';

import 'package:dio/dio.dart';

abstract class SSLInterceptor extends InterceptorsWrapper {
  void onHandshakeException(DioException dioException, ErrorInterceptorHandler handler);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is HandshakeException) {
      onHandshakeException(err, handler);
    } else {
      super.onError(err, handler);
    }
  }
}
