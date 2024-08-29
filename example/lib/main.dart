import 'dart:io';

import 'package:example/data/dto/model/ssl_fingerprint_model.dart';
import 'package:example/data/repository/repository_datasource.dart';
import 'package:example/data/state/fetch_network_state.dart';
import 'package:example/domain/interceptor/dynamic_ssl_interceptor.dart';
import 'package:example/firebase_options.dart';
import 'package:example/presentation/main_store.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:example/presentation/widget/info_bottomsheet.dart';
import 'package:example/presentation/widget/loading_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_feature_platform/flutter_feature_platform.dart';
import 'package:mobx/mobx.dart';

import 'data/dto/model/feature_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Alice alice;
  late FirebaseRemoteConfig remoteConfig;
  bool isAllFullySetup = false;
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
    remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 60),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    GetIt.I.registerSingleton(remoteConfig);
    GetIt.I.get<FirebaseRemoteConfig>().fetchAndActivate();
    GetIt.I.get<FirebaseRemoteConfig>().ensureInitialized();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isAllFullySetup = true;
      });
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
    return isAllFullySetup
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
      title: 'Fetched Post',
      desc: 'Fetched Post - Correct Fingerprint',
      key: 'FETCHED_POST_CORRECT_FINGERPRINT',
    ),
    FeatureModel(
      title: 'Fetched Post',
      desc: 'Fetched Post - Incorrect Fingerprint',
      key: 'FETCHED_POST_INCORRECT_FINGERPRINT',
    ),
    FeatureModel(
      title: 'Fetched Post',
      desc: 'Fetched Post - Dynamic Fingerprint',
      key: 'FETCHED_POST_DYNAMIC_FINGERPRINT',
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
    final placeHolderStandardDio = GetIt.I.get<FeatureNetworkRepository>().getDioClient();
    final placeHolderCorrectFingerprintDio = GetIt.I.get<FeatureNetworkRepository>().getDioClient(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      headers: {
        HttpHeaders.userAgentHeader: userAgent,
      },
      interceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      allowedFingerprints: [
        '14f9996f9481eac7f9c005f6954c2f032d8e9cb13d4440ebed35f14bed22c43f',
      ],
    );
    final placeHolderIncorrectFingerprintDio = GetIt.I.get<FeatureNetworkRepository>().getDioClient(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      headers: {
        HttpHeaders.userAgentHeader: userAgent,
      },
      interceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      allowedFingerprints: [
        '065e3b66390a5d3c7ce51f27342442606453b3d98e4d4e97f5b708b59d190a0a',
      ],
    );
    final placeHolderDynamicSslFingerprintDio = GetIt.I.get<FeatureNetworkRepository>().getDioClient(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      headers: {
        HttpHeaders.userAgentHeader: userAgent,
      },
      interceptors: [
        DynamicSslInterceptor(remoteConfig: GetIt.I.get<FirebaseRemoteConfig>()),
        GetIt.I.get<Alice>().getDioInterceptor(),
        LoggerInterceptor(),
      ],
    );
    mainStore = MainStore(
      repositoryDatasource: RepositoryDatasourceImpl(
        placeHolderStandardDio: placeHolderStandardDio,
        placeHolderCorrectFingerprintDio: placeHolderCorrectFingerprintDio,
        placeHolderIncorrectFingerprintDio: placeHolderIncorrectFingerprintDio,
        placeHolderDynamicFingerprintDio: placeHolderDynamicSslFingerprintDio,
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
                      case "FETCHED_POST_CORRECT_FINGERPRINT":
                        mainStore.getPostByIdCorrectFingerprint();
                        break;
                      case "FETCHED_POST_INCORRECT_FINGERPRINT":
                        mainStore.getPostByIdIncorrectFingerprint();
                        break;
                      case "FETCHED_POST_DYNAMIC_FINGERPRINT":
                        mainStore.getPostByIdDynamicFingerprint();
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
