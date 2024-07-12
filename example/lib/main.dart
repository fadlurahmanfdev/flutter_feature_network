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
  late Dio sslDio;

  @override
  void initState() {
    super.initState();
    FeatureNetworkRepository networkRepository = FeatureNetworkRepositoryImpl();
    GetIt.I.registerFactory<FeatureNetworkRepository>(() => networkRepository);
    GetIt.I.registerFactory<FeaturePlatformRepository>(() => FeaturePlatformRepositoryImpl());
    alice = Alice(showNotification: true, showInspectorOnShake: true);
    GetIt.I.registerSingleton(alice);
    GetIt.I.get<FeaturePlatformRepository>().getUserAgent().then((ua) {
      print("MASUK_ GET USER AGENT: $ua");
      rootBundle.load("assets/retail_dev_bank_mas_net.pem").then((byteData) {
        print("MASUK_ GET TRUSTED CERT BYTES");
        sslDio = GetIt.I.get<FeatureNetworkRepository>().getDio(
              baseUrl: 'https://api.bankmas.my.id/',
              interceptors: [
                LoggerInterceptor(),
                ExampleSSLInterceptor(),
                alice.getDioInterceptor(),
              ],
              headers: {
                HttpHeaders.userAgentHeader: ua,
              },
              trustedCertificateBytes: byteData.buffer.asUint8List(),
            );
        GetIt.I.registerFactory<Dio>(() => sslDio, instanceName: 'ssl-dio');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: alice.getNavigatorKey(),
      title: 'Flutter Network Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
