import 'dart:io';

import 'package:example/data/repository/repository_datasource.dart';
import 'package:example/data/state/fetch_network_state.dart';
import 'package:example/presentation/main_store.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:example/presentation/widget/info_bottomsheet.dart';
import 'package:example/presentation/widget/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_feature_platform/flutter_feature_platform.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'data/dto/model/feature_model.dart';

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
  late Dio placeHolderStandardDio;
  late Dio sslDio;

  @override
  void initState() {
    super.initState();
    FeatureNetworkRepository networkRepository = FeatureNetworkRepositoryImpl();
    GetIt.I.registerFactory<FeatureNetworkRepository>(() => networkRepository);
    GetIt.I.registerFactory<FeaturePlatformRepository>(() => FeaturePlatformRepositoryImpl());
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
            home: const SizedBox.shrink(),
          );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainStore mainStore;
  bool isInitialized = false;
  List<FeatureModel> features = [
    FeatureModel(
      title: 'Fetched Post',
      desc: 'Fetched Post - OK',
      key: 'FETCHED_POST_OK',
    ),
    FeatureModel(
      title: 'SSL Network',
      desc: 'SSL Network',
      key: 'SSL_NETWORK',
    ),
  ];
  List<ReactionDisposer> reactions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        init();
      },
    );
  }

  Future<void> init() async {
    final userAgent = await GetIt.I.get<FeaturePlatformRepository>().getUserAgent();
    final placeHolderStandardDio = GetIt.I.get<FeatureNetworkRepository>().getDioClient(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      headers: {
        HttpHeaders.userAgentHeader: userAgent,
      },
      interceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
    );
    final sslDio = GetIt.I.get<FeatureNetworkRepository>().getDioClient(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      headers: {
        HttpHeaders.userAgentHeader: userAgent,
      },
      interceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
    );
    mainStore = MainStore(
      repositoryDatasource: RepositoryDatasourceImpl(
        placeHolderStandardDio: placeHolderStandardDio,
        sslDio: sslDio,
      ),
    );
    reactions = [
      reaction((p0) => mainStore.fetchNetworkState, (p0) {
        if (p0 is FetchNetworkLoadingState) {
          showLoading();
        } else if (p0 is FetchNetworkSuccessState) {
          Navigator.pop(context);
          showInfo(title: 'OK', desc: 'Success/Sukses');
        } else if (p0 is FetchNetworkFailedState) {
          Navigator.pop(context);
          showInfo(title: p0.exception.title, desc: p0.exception.desc);
        }
      })
    ];

    setState(() {
      isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NETWORK')),
      body: isInitialized
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: features.length,
              itemBuilder: (_, index) {
                final feature = features[index];
                return GestureDetector(
                  onTap: () async {
                    switch (feature.key) {
                      case "FETCHED_POST_OK":
                        mainStore.getPostById();
                        break;
                      case "SSL_NETWORK":
                        break;
                    }
                  },
                  child: ItemFeatureWidget(feature: feature),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void showLoading() {
    showDialog(
      context: context,
      builder: (_) {
        return const LoadingDialog();
      },
    );
  }

  void showInfo({required String title, required String desc}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (_) {
        return InfoBottomsheet(title: title, desc: desc);
      },
    );
  }
}
