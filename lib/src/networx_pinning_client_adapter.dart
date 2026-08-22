import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/io.dart';
import 'package:networx/src/networx_security.dart';

class NetworxPinningClientAdapter extends IOHttpClientAdapter {
  final List<String>? pinningHash;

  NetworxPinningClientAdapter({this.pinningHash});

  @override
  ValidateCertificate? get validateCertificate => (cert, host, port) {
    if (pinningHash != null) {
      if(cert == null) return false;
      final derBytes = cert.der;
      final certHash = sha256.convert(derBytes).toString();
      final spkiHash = NetworxSecurity.getSpkiPin(cert);
      final isCertMatched = pinningHash!.contains(certHash);
      final isSpkiMatched = pinningHash!.contains(spkiHash);
      log('isCertMatched: $isCertMatched');
      log('isSpkiMatched: $isSpkiMatched');
      return isCertMatched || isSpkiMatched;
    }

    return true;
  };
}
