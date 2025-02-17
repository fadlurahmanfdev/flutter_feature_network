// ignore_for_file: non_constant_identifier_names
import 'package:networx/src/exception/networx_exception.dart';

class ExceptionConstant {
  static NetworxException CONNECTION_NOT_SECURE = NetworxException(code: 'CONNECTION_NOT_SECURE', message: 'Connection not secure');
  static NetworxException BAD_FINGERPRINT = NetworxException(code: 'BAD_FINGERPRINT', message: null);
}