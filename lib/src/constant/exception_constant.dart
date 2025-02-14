// ignore_for_file: non_constant_identifier_names
import 'package:networx/src/exception/networx_exception.dart';

class ExceptionConstant {
  static NetworxException FINGERPRINT_CERTIFICATE_NOT_VALID = NetworxException(code: 'FINGERPRINT_CERTIFICATE_NOT_VALID', message: 'SHA fingerprint not matched or valid with http certificate base url');
  static NetworxException BAD_FINGERPRINT = NetworxException(code: 'BAD_FINGERPRINT', message: null);
}