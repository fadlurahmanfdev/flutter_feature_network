import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends InterceptorsWrapper {
  final bool showLogRequest;
  final bool showLogResponse;
  final bool showLogError;

  LoggerInterceptor({
    this.showLogRequest = true,
    this.showLogResponse = true,
    this.showLogError = true,
  });

  final logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (showLogRequest) {
      String loggerText = "API-REQUEST";
      loggerText += "\nAPI PATH: ${options.baseUrl}${options.path}";
      loggerText += "\nMETHOD: ${options.method}";
      loggerText += "\nHEADER: ${options.headers}";
      if (options.data != null) {
        loggerText += "\nDATA: ${options.data}";
      }
      logger.d(loggerText);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (showLogResponse) {
      String loggerText = "API-RESPONSE";
      loggerText += "\nAPI PATH: ${response.requestOptions.baseUrl}${response.requestOptions.path}";
      loggerText += "\nMETHOD: ${response.requestOptions.method}";
      loggerText += "\nREQUEST";
      loggerText += "\nHEADER: ${response.requestOptions.headers}";
      if (response.requestOptions.data != null) {
        loggerText += "\nREQUEST DATA: ${response.requestOptions.data}";
      }
      loggerText += "\nRESPONSE";
      loggerText += "\nHTTP STATUS CODE: ${response.statusCode}";
      loggerText += "\nRESPONSE DATA: ${response.data}";
      logger.i(loggerText);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (showLogError) {
      String loggerText = "ERROR API-RESPONSE";
      loggerText += "\nAPI PATH: ${err.requestOptions.baseUrl}${err.requestOptions.path}";
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
      logger.e(loggerText);
    }
    super.onError(err, handler);
  }
}
