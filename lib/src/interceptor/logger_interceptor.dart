import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// A Dio interceptor that prints each API call in a readable log.
///
/// Add this in development when you need to see the path, headers, body,
/// status, and error of every request without attaching a proxy. Turn the
/// flags off in production if you do not want traffic details in the console.
///
/// Example:
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(LoggerInterceptor());
/// ```
class LoggerInterceptor extends InterceptorsWrapper {
  /// Whether outgoing requests are written to the log. Defaults to `true`.
  final bool showLogRequest;

  /// Whether successful responses are written to the log. Defaults to `true`.
  final bool showLogResponse;

  /// Whether failed requests are written to the log. Defaults to `true`.
  final bool showLogError;

  /// Creates a logging interceptor.
  ///
  /// [showLogRequest] logs the method, path, headers, and body before send.
  /// [showLogResponse] logs the status and body after a successful call.
  /// [showLogError] logs the type, status, and explanation of a failed call.
  LoggerInterceptor({
    this.showLogRequest = false,
    this.showLogResponse = true,
    this.showLogError = true,
  });

  final _logger = Logger();

  /// Logs the request, then forwards it to the next interceptor.
  ///
  /// [options] is the outgoing request.
  /// [handler] continues or rejects the chain.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (showLogRequest) {
      String loggerText = "API-REQUEST";
      loggerText += "\nDATE TIME: ${DateTime.now()}";
      loggerText += "\nAPI PATH: ${options.baseUrl}${options.path}";
      loggerText += "\nMETHOD: ${options.method}";
      loggerText += "\nHEADER: ${options.headers}";
      if (options.data != null) {
        loggerText += "\nDATA: ${options.data}";
      }
      _logger.d(loggerText);
    }
    super.onRequest(options, handler);
  }

  /// Logs the response, then forwards it to the next interceptor.
  ///
  /// [response] is the server result.
  /// [handler] continues or rejects the chain.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (showLogResponse) {
      String loggerText = "API-RESPONSE";
      loggerText += "\nDATE TIME: ${DateTime.now()}";
      loggerText +=
          "\nAPI PATH: ${response.requestOptions.baseUrl}${response.requestOptions.path}";
      loggerText += "\nMETHOD: ${response.requestOptions.method}";
      loggerText += "\nREQUEST";
      loggerText += "\nHEADER: ${response.requestOptions.headers}";
      if (response.requestOptions.data != null) {
        loggerText += "\nREQUEST DATA: ${response.requestOptions.data}";
      }
      loggerText += "\nRESPONSE";
      loggerText += "\nHTTP STATUS CODE: ${response.statusCode}";
      loggerText += "\nRESPONSE DATA: ${response.data}";
      _logger.i(loggerText);
    }
    super.onResponse(response, handler);
  }

  /// Logs the failure, then forwards it to the next interceptor.
  ///
  /// [err] is the Dio error from the failed call.
  /// [handler] continues or rejects the chain.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (showLogError) {
      String loggerText = "ERROR API REQUEST";
      loggerText += "\nERROR TYPE: ${err.type}";
      loggerText +=
          "\nAPI PATH: ${err.requestOptions.baseUrl}${err.requestOptions.path}";
      loggerText += "\nMETHOD: ${err.requestOptions.method}";
      loggerText += "\nREQUEST";
      loggerText += "\nHEADER: ${err.requestOptions.headers}";
      if (err.requestOptions.data != null) {
        loggerText += "\nREQUEST DATA: ${err.requestOptions.data}";
      }
      loggerText += "\nERROR";
      loggerText += "\nHTTP STATUS CODE: ${err.response?.statusCode}";
      loggerText += "\nRESPONSE DATA: ${err.response?.data}";
      loggerText += "\nEXPLANATION: ${err.error}";
      _logger.e(loggerText);
    }
    super.onError(err, handler);
  }
}
