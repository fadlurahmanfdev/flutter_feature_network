import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:networx/flutter_feature_network.dart';
import 'package:path_provider/path_provider.dart';

class DownloadableSSLInterceptor extends NetworxHandshakeSSLInterceptor {
  FirebaseRemoteConfig remoteConfig;

  DownloadableSSLInterceptor({required this.remoteConfig});

  @override
  void onHandshakeException(DioException dioException, ErrorInterceptorHandler handler) async {
    try {
      log("handshake ssl exception happened");
      final tempDirectory = await getTemporaryDirectory();
      log("try to downloading into directory: ${tempDirectory.path}");
      if (tempDirectory.existsSync()) {
        log("start processing fetch remote config");
        await remoteConfig.fetchAndActivate();
        Map<String, String> sslCertModel = json.decode(remoteConfig.getString('SSL_CERTIFICATE'));
        log("get map ssl cert model: $sslCertModel");
        final sslCertName = sslCertModel['name'];
        final sslCertUrl = sslCertModel['url'];
        final newPemCertificateFile = File('${tempDirectory.path}/$sslCertName');
        if (!newPemCertificateFile.existsSync()) {
          log("start downloading new pem file from remote config");
          final downloadableDio = Dio();
          await downloadableDio.downloadUri(
            Uri.parse(sslCertUrl ?? ''),
            newPemCertificateFile.path,
            onReceiveProgress: (count, total) {
              log("downloaded $count from $total");
            },
          );
          log("successfully download pem file");
          if (newPemCertificateFile.existsSync()) {
            log("pem file already downloaded into ${newPemCertificateFile.path}");
            log("retry last request with new pem file");
            final retryableDio = NetworxDio.getClient(
              dio: Dio(),
              trustedCertificateBytes: newPemCertificateFile.readAsBytesSync(),
            );
            final retryResponse = await retryableDio.fetch(dioException.requestOptions);
            log("successfully retry response");
            handler.resolve(retryResponse);
          } else {
            log("pem file not exist in ${newPemCertificateFile.path}");
            handler.next(dioException);
          }
        } else {
          log("file with ${newPemCertificateFile.path} already exist on device");
          handler.next(dioException);
        }
      } else {
        log("directory not exist");
        handler.next(dioException);
      }
    } catch (e) {
      handler.next(DioException(requestOptions: dioException.requestOptions, type: DioExceptionType.unknown, error: e));
    }
  }
}
