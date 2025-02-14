import 'package:flutter/services.dart';

class NetworxUtils {
  static Future<Uint8List> getCertificateBytesFromAsset({
    required String assetPath,
  }) async {
    return rootBundle.load(assetPath).then((byteData) {
      return byteData.buffer.asUint8List();
    });
  }
}