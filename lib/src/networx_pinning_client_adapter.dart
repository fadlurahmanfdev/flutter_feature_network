import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/io.dart';

import 'networx_pinning_utils.dart';

class NetworxPinningClientAdapter extends IOHttpClientAdapter {
  final List<int>? certificateBytes;
  final List<String>? pinningHash;

  NetworxPinningClientAdapter({this.certificateBytes, this.pinningHash});

  @override
  CreateHttpClient? get createHttpClient => () {
    if (certificateBytes != null) {
      final securityContext = SecurityContext();
      securityContext.setTrustedCertificatesBytes(certificateBytes!);
      return HttpClient(context: securityContext);
    }

    return super.createHttpClient!();
  };

  @override
  ValidateCertificate? get validateCertificate => (cert, host, port) {
    if (pinningHash != null) {
      if (cert == null) return false;
      final derBytes = cert.der;
      final certHash = sha256.convert(derBytes).toString();
      final spkiHash = NetworxPinningUtils.getSpkiPin(cert);
      final isCertMatched = pinningHash!.contains(certHash);
      final isSpkiMatched = pinningHash!.contains(spkiHash);
      log('isCertMatched: $isCertMatched');
      log('isSpkiMatched: $isSpkiMatched');
      return isCertMatched || isSpkiMatched;
    }

    return true;
  };
}
