import 'dart:convert';
import 'dart:io';

import 'package:asn1lib/asn1lib.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/// Helpers that turn certificates into pins your app can store and reuse.
///
/// Use these when you need a PEM from assets, a certificate hash, or a
/// public-key (SPKI) pin — then pass the result to
/// [NetworxPinningClientAdapter].
class NetworxPinningUtils {
  /// Loads a PEM certificate from a Flutter asset.
  ///
  /// Keep the PEM in your app bundle when you want a known certificate
  /// available offline. The returned bytes can be passed to
  /// [NetworxPinningClientAdapter.certificateBytes].
  ///
  /// [assetPath] is the asset path declared in `pubspec.yaml`, for example
  /// `assets/api_cert.pem`.
  ///
  /// Example:
  /// ```dart
  /// final pem = await NetworxPinningUtils.getCertificateBytesFromAsset(
  ///   assetPath: 'assets/api_cert.pem',
  /// );
  /// ```
  static Future<Uint8List> getCertificateBytesFromAsset({
    required String assetPath,
  }) async {
    return rootBundle.load(assetPath).then((byteData) {
      return byteData.buffer.asUint8List();
    });
  }

  /// Creates a SHA-256 hash of the full certificate.
  ///
  /// Use this when you want the pin to match one exact certificate. If the
  /// server renews the cert, this hash will change and the pin must be
  /// updated.
  ///
  /// [certificate] is the live X.509 certificate from the TLS handshake.
  ///
  /// Returns a lowercase hex SHA-256 string.
  ///
  /// Example:
  /// ```dart
  /// final hash = NetworxPinningUtils.getHash(certificate);
  /// ```
  static String getHash(X509Certificate certificate) {
    final derBytes = certificate.der;
    return sha256.convert(derBytes).toString().toLowerCase();
  }

  /// Creates a public-key (SPKI) pin from a certificate.
  ///
  /// Prefer this when certificates rotate often but the same key is reused.
  /// The pin stays valid across renewals until the server changes its key.
  ///
  /// [certificate] is the live X.509 certificate from the TLS handshake.
  ///
  /// Returns `Base64(SHA-256(DER-encoded SubjectPublicKeyInfo))`, the same
  /// format OpenSSL produces for SPKI pins.
  ///
  /// Example:
  /// ```dart
  /// final spki = NetworxPinningUtils.getSpkiPin(certificate);
  /// // fj/LGYZh+mUuNimcCT6b6V6MLFW1SIzcsM4hgwSwVB4=
  /// ```
  static String getSpkiPin(X509Certificate certificate) {
    final parser = ASN1Parser(certificate.der);

    // Certificate → tbsCertificate, signatureAlgorithm, signatureValue.
    final certificateSequence = parser.nextObject() as ASN1Sequence;
    final tbsCertificate = certificateSequence.elements[0] as ASN1Sequence;

    var index = 0;

    // Optional [0] EXPLICIT Version.
    if (tbsCertificate.elements[0].tag == 0xA0) {
      index++;
    }

    // serialNumber, signature, issuer, validity, subject.
    index += 5;

    // Next field is SubjectPublicKeyInfo (SPKI). Hash the original DER
    // bytes — not the full certificate and not a rebuilt public key.
    final spki = tbsCertificate.elements[index];
    final spkiDer = Uint8List.fromList(spki.encodedBytes);
    final digest = sha256.convert(spkiDer);
    return base64Encode(digest.bytes);
  }
}
