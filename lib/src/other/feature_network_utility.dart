import 'package:dio/dio.dart';

class FeatureNetworkUtility {
  Dio getDio({
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Duration? connectTimeout,
    String baseUrl = '',
    Map<String, dynamic>? headers,
    List<Interceptor>? interceptors,
  }) {
    final dio = Dio(
      BaseOptions(
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        connectTimeout: connectTimeout,
        baseUrl: baseUrl,
        headers: headers,
      ),
    );
    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }
    return dio;
  }
}
