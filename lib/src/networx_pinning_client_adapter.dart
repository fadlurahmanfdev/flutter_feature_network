import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/io.dart';

import 'networx_pinning_utils.dart';

/// A Dio HTTP adapter that only talks to servers you already trust.
///
/// Attach this adapter to a Dio client when you want TLS to fail closed:
/// if the live certificate does not match a pin or PEM you provided, the
/// request is rejected. That protects login, payments, and other sensitive
/// calls from a silent man-in-the-middle on public Wi-Fi.
///
/// You can pin in two ways:
/// - [certificateBytes] trusts a PEM file you ship with the app.
/// - [pinningHash] accepts SHA-256 certificate hashes and/or SPKI pins.
///
/// Example:
/// ```dart
/// final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
/// dio.httpClientAdapter = NetworxPinningClientAdapter(
///   pinningHash: ['fj/LGYZh+mUuNimcCT6b6V6MLFW1SIzcsM4hgwSwVB4='],
/// );
/// ```
class NetworxPinningClientAdapter extends IOHttpClientAdapter {
  /// PEM certificate bytes that this client should treat as trusted.
  ///
  /// Load them with [NetworxPinningUtils.getCertificateBytesFromAsset].
  /// When this is set, the HTTP client uses only that certificate as its
  /// trust store instead of the device’s default CAs.
  final List<int>? certificateBytes;

  /// Allowed SHA-256 certificate hashes and/or SPKI pins.
  ///
  /// Each value is compared to:
  /// - the SHA-256 hash of the full certificate (hex string), and
  /// - the SPKI pin of the same certificate (Base64 string).
  ///
  /// The handshake succeeds when either form matches. Use this when you
  /// know the server’s certificate hash, its public-key pin, or both.
  final List<String>? pinningHash;

  /// Creates an adapter that pins by PEM bytes, hash values, or both.
  ///
  /// [certificateBytes] is the PEM file you want this client to trust.
  /// Pass `null` to keep the device trust store.
  ///
  /// [pinningHash] is the list of certificate hashes and SPKI pins that
  /// may pass TLS. Pass `null` to skip hash pinning.
  NetworxPinningClientAdapter({this.certificateBytes, this.pinningHash});

  /// Builds the underlying HTTP client for each request.
  ///
  /// When [certificateBytes] is provided, the client trusts only that PEM.
  /// That is useful when you want the app to ignore public CAs and accept
  /// one known certificate only.
  @override
  CreateHttpClient? get createHttpClient => () {
        if (certificateBytes != null) {
          final securityContext = SecurityContext();
          securityContext.setTrustedCertificatesBytes(certificateBytes!);
          return HttpClient(context: securityContext);
        }

        return super.createHttpClient!();
      };

  /// Decides whether the live TLS certificate is allowed to continue.
  ///
  /// When [pinningHash] is set, the request is allowed only if the server
  /// certificate hash or SPKI pin appears in that list. When it is not set,
  /// the handshake is left to the usual TLS checks.
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
