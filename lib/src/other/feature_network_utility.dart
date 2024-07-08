import 'package:dio/dio.dart';

class FeatureNetworkUtility {
  Dio getDio({
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Duration? connectTimeout,
    String baseUrl = '',
    List<Interceptor>? interceptors,
  }) {
    final dio = Dio(
      BaseOptions(
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        connectTimeout: connectTimeout,
        baseUrl: baseUrl,
        headers: {
          'tes': 'tes',
        },
      ),
    );
    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }
    return dio;
  }
}
