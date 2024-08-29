import 'package:flutter/services.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';

class ExampleSSLInterceptor extends SSLInterceptor {
  FeatureNetworkRepository networkRepository = FeatureNetworkRepositoryImpl();

  @override
  void onHandshakeException(DioException dioException, ErrorInterceptorHandler handler) async {
    try {
      rootBundle.load("assets/api_bank_mas_my_id.pem").then((byteData) async {
        final dio = networkRepository.getDio(
          baseUrl: dioException.requestOptions.baseUrl,
          headers: dioException.requestOptions.headers,
          interceptors: [
            LoggerInterceptor(),
          ],
          trustedCertificateBytes: byteData.buffer.asUint8List(),
        );
        final result = await dio.fetch(dioException.requestOptions);
        handler.resolve(result);
      });
    } catch (e) {
      handler.next(dioException);
    }
  }
}
