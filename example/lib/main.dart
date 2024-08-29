import 'dart:io';

import 'package:example/domain/interceptor/example_ssl_interceptor.dart';
import 'package:example/presentation/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_feature_platform/flutter_feature_platform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Alice alice;
  bool isAliceRegistered = false;
  late Dio sslDio;

  @override
  void initState() {
    super.initState();
    // FeatureNetworkRepository networkRepository = FeatureNetworkRepositoryImpl();
    // GetIt.I.registerFactory<FeatureNetworkRepository>(() => networkRepository);
    // GetIt.I.registerFactory<FeaturePlatformRepository>(() => FeaturePlatformRepositoryImpl());
    alice = Alice(showNotification: true, showInspectorOnShake: true);
    GetIt.I.registerSingleton(alice);
    setState(() {
      isAliceRegistered = true;
    });
    // GetIt.I.get<FeaturePlatformRepository>().getUserAgent().then((ua) {
    //   print("MASUK_ GET USER AGENT: $ua");
    //   rootBundle.load("assets/retail_dev_bank_mas_net.pem").then((byteData) {
    //     print("MASUK_ GET TRUSTED CERT BYTES");
    //     sslDio = GetIt.I.get<FeatureNetworkRepository>().getDioClient(
    //           baseUrl: 'https://api.bankmas.my.id/',
    //           interceptors: [
    //             LoggerInterceptor(),
    //             ExampleSSLInterceptor(),
    //             alice.getDioInterceptor(),
    //           ],
    //           headers: {
    //             HttpHeaders.userAgentHeader: ua,
    //           },
    //           trustedCertificateBytes: byteData.buffer.asUint8List(),
    //         );
    //     GetIt.I.registerFactory<Dio>(() => sslDio, instanceName: 'ssl-dio');
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return isAliceRegistered
        ? MaterialApp(
            navigatorKey: alice.getNavigatorKey(),
            title: 'Flutter Feature Network',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
              useMaterial3: true,
            ),
            home: const MainPage(),
          )
        : MaterialApp(
            title: 'Flutter Feature Network - Non Alice',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
              useMaterial3: true,
            ),
            home: const MainPage(),
          );
  }
}
