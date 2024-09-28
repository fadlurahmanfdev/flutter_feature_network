import 'package:flutter/services.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';

class ExampleSSLInterceptor extends SSLInterceptor {
  FeatureNetworkRepository networkRepository = FeatureNetworkRepositoryImpl();

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
