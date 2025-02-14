import 'package:dio/dio.dart';
import 'package:networx/flutter_feature_network.dart';

class ExampleSSLInterceptor extends NetworxHandshakeSSLInterceptor {
  @override
  void onHandshakeException(DioException dioException, ErrorInterceptorHandler handler) async {
    try {
      // on handshake exception
      handler.next(dioException);
    } catch (e) {
      handler.next(dioException);
    }
  }
}
