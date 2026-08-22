import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:networx/networx.dart';

// class RetryableCertificatePinningInterceptor extends NetworxCertificatePinningInterceptor {
//   RetryableCertificatePinningInterceptor({required super.allowedSHAFingerprints});
//
//   @override
//   void onConnectionNotSecure(RequestOptions options, RequestInterceptorHandler handler) {
//     log("app certificate pinning -> on connection not secure");
//     super.onConnectionNotSecure(options, handler);
//   }
//
//   @override
//   void onBadFingerPrint(RequestOptions options, RequestInterceptorHandler handler, NetworxException exception) async {
//     log("app certificate pinning -> on bad fingerprint");
//     List<String> allowedFingerprints = <String>[];
//     // process look another corrected fingerprint
//     allowedFingerprints = [
//       'c19017fc3b6d30f06dae6f7049f296560212b6ac826fe0e3ca24dd1b4912e92b',
//     ];
//     try {
//       final dio = NetworxDio.getClient(
//         dio: Dio(),
//         prefixInterceptors: [
//           LoggerInterceptor(),
//         ],
//         allowedFingerprints: allowedFingerprints,
//       );
//       final response = await dio.fetch(options..headers['Reactivate-SSL'] = true);
//       handler.resolve(response);
//     } catch (e) {
//       super.onBadFingerPrint(options, handler, exception);
//     }
//   }
// }
