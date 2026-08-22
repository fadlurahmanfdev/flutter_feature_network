import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:crypto/crypto.dart';

class NetworxSecurity {
  // String getHash(X509Certificate certificate){
  //   final derBytes = certificate.der;
  //   return sha256.convert(derBytes).toString().toLowerCase();
  // }

  /// Extracts the SHA-256 SPKI pin from an X.509 certificate.
  ///
  /// Result format:
  ///   Base64(SHA-256(DER-encoded SubjectPublicKeyInfo))
  ///
  /// Example:
  ///   fj/LGYZh+mUuNimcCT6b6V6MLFW1SIzcsM4hgwSwVB4=
  static String getSpkiPin(X509Certificate certificate) {
    // The certificate DER is the original binary X.509 certificate
    // received from the TLS connection.
    final parser = ASN1Parser(certificate.der);

    // X.509 Certificate structure:
    //
    // Certificate
    // ├── tbsCertificate       <-- we need this
    // ├── signatureAlgorithm
    // └── signatureValue
    //
    final certificateSequence =
    parser.nextObject() as ASN1Sequence;

    final tbsCertificate =
    certificateSequence.elements[0] as ASN1Sequence;

    var index = 0;

    // TBSCertificate optionally starts with:
    //
    // [0] EXPLICIT Version
    //
    // If version exists, skip it.
    if (tbsCertificate.elements[0].tag == 0xA0) {
      index++;
    }

    // Skip serialNumber.
    index++;

    // Skip signature algorithm.
    index++;

    // Skip issuer.
    index++;

    // Skip validity.
    index++;

    // Skip subject.
    index++;

    // The next field is SubjectPublicKeyInfo (SPKI).
    //
    // This is the important part:
    //
    // TBSCertificate
    // ├── version
    // ├── serialNumber
    // ├── signature
    // ├── issuer
    // ├── validity
    // ├── subject
    // └── SubjectPublicKeyInfo  <-- WE WANT THIS
    //
    final spki = tbsCertificate.elements[index];

    // IMPORTANT:
    // Use the ORIGINAL DER-encoded SPKI bytes.
    //
    // Do NOT hash:
    //   - the entire certificate
    //   - only the public-key BIT STRING
    //   - the RSA modulus
    //   - a reconstructed public-key object
    //
    // OpenSSL's:
    //
    //   openssl x509 -pubkey
    //   | openssl pkey -pubin -outform DER
    //
    // produces this exact DER-encoded SPKI structure.
    final spkiDer = Uint8List.fromList(spki.encodedBytes);

    // SPKI pinning = SHA-256 of the DER-encoded SPKI.
    final digest = sha256.convert(spkiDer);

    // OpenSSL outputs the SHA-256 digest as Base64.
    return base64Encode(digest.bytes);
  }
}
