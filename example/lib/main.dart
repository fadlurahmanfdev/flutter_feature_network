import 'dart:io';

import 'package:alice/alice.dart';
import 'package:example/data/repository/repository_datasource.dart';
import 'package:example/data/state/fetch_network_state.dart';
import 'package:example/domain/interceptor/retry_certificate_pinning_interceptor.dart';
import 'package:example/domain/interceptor/configurable_ssl_interceptor.dart';
import 'package:example/domain/interceptor/downloadable_ssl_interceptor.dart';
import 'package:example/firebase_options.dart';
import 'package:example/presentation/main_store.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:example/presentation/widget/info_bottomsheet.dart';
import 'package:example/presentation/widget/loading_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:networx/networx.dart';
import 'package:dio/io.dart';

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
    NetworxDio networkRepository = NetworxDio();
    GetIt.I.registerFactory<NetworxDio>(() => networkRepository);
    // GetIt.I.registerFactory<FeaturePlatformRepository>(() => FeaturePlatformRepositoryImpl());
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
  }

  @override
  Widget build(BuildContext context) {
    return isAllFullySetup
        ? MaterialApp(
            navigatorKey: alice.getNavigatorKey(),
            title: 'Networx',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
              useMaterial3: true,
            ),
            home: const MainPage(),
          )
        : MaterialApp(
            title: 'Networx - Non Alice',
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
      title: 'Dio Client for Burp Suite',
      desc: 'Dio Client for Burp Suite',
      key: 'DIO_CLIENT_FOR_BURP_SUITE',
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
      title: 'Retryable Incorrect Fingerprint',
      desc: 'Retryable Incorrect Fingerprint',
      key: 'RETRYABLE_INCORRECT_FINGERPRINT',
    ),
    FeatureModel(
      title: 'Fetched Post',
      desc: 'Fetched Post - Configurable Fingerprint',
      key: 'FETCHED_POST_CONFIGURABLE_FINGERPRINT',
    ),
    FeatureModel(
      title: 'Fetched Post',
      desc: 'Fetched Post - Correct Certificate Byte',
      key: 'FETCHED_POST_CORRECT_CERTIFICATE_BYTE',
    ),
    FeatureModel(
      title: 'Fetched Post',
      desc: 'Fetched Post - Incorrect Certificate Byte',
      key: 'FETCHED_POST_INCORRECT_CERTIFICATE_BYTE',
    ),
    FeatureModel(
      title: 'Fetched Post',
      desc: 'Fetched Post - Downloadable Certificate Byte',
      key: 'FETCHED_POST_DOWNLOADABLE_CERTIFICATE_BYTE',
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
    // final userAgent = await GetIt.I.get<FeaturePlatformRepository>().getUserAgent();
    final placeHolderStandardDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      suffixInterceptors: [],
    );
    final customBurpSuiteProxyDio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
    ));
    customBurpSuiteProxyDio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (_, __, ___){
        return true;
      };
      client.findProxy = (uri) {
        return 'PROXY 192.168.1.16:8888';
      };
      return client;
    });
    final placeHolderCorrectFingerprintDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        headers: {
          // HttpHeaders.userAgentHeader: userAgent,
        },
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      allowedFingerprints: [
        'c19017fc3b6d30f06dae6f7049f296560212b6ac826fe0e3ca24dd1b4912e92b',
      ],
    );
    final placeHolderIncorrectFingerprintDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        headers: {
          // HttpHeaders.userAgentHeader: userAgent,
        },
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      allowedFingerprints: [
        '065e3b66390a5d3c7ce51f27342442606453b3d98e4d4e97f5b708b59d190a0a',
      ],
    );
    final placeHolderRetryableIncorrectFingerprintDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        headers: {
          // HttpHeaders.userAgentHeader: userAgent,
        },
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      customCertificatePinningInterceptor: RetryableCertificatePinningInterceptor(
        allowedSHAFingerprints: [
          '065e3b66390a5d3c7ce51f27342442606453b3d98e4d4e97f5b708b59d190a0a',
        ],
      ),
    );
    final placeHolderConfigurableSslFingerprintDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        headers: {
          // HttpHeaders.userAgentHeader: userAgent,
        },
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
        ConfigurableSSLInterceptor(remoteConfig: GetIt.I.get<FirebaseRemoteConfig>()),
      ],
    );
    final jsonPlaceholderCertByte =
        await NetworxUtils.getCertificateBytesFromAsset(assetPath: 'assets/jsonplaceholder_cert.pem');
    final wikipediaCertByte = await NetworxUtils.getCertificateBytesFromAsset(assetPath: 'assets/wikipedia_cert.pem');
    final correctCertificateByteDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        headers: {
          // HttpHeaders.userAgentHeader: userAgent,
        },
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      trustedCertificateBytes: jsonPlaceholderCertByte,
    );
    final incorrectCertificateByteDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        headers: {
          // HttpHeaders.userAgentHeader: userAgent,
        },
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
      ],
      trustedCertificateBytes: wikipediaCertByte,
    );

    final downloadableSSLCertificateByteDio = NetworxDio.getClient(
      dio: Dio(BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        headers: {
          // HttpHeaders.userAgentHeader: userAgent,
        },
      )),
      prefixInterceptors: [
        LoggerInterceptor(),
        GetIt.I.get<Alice>().getDioInterceptor(),
        DownloadableSSLInterceptor(remoteConfig: GetIt.I.get<FirebaseRemoteConfig>()),
      ],
      trustedCertificateBytes: wikipediaCertByte,
    );
    mainStore = MainStore(
      repositoryDatasource: RepositoryDatasourceImpl(
        placeHolderStandardDio: placeHolderStandardDio,
        customProxyDioBurpSuite: customBurpSuiteProxyDio,
        placeHolderCorrectFingerprintDio: placeHolderCorrectFingerprintDio,
        placeHolderIncorrectFingerprintDio: placeHolderIncorrectFingerprintDio,
        placeHolderRetryableIncorrectFingerprintDio: placeHolderRetryableIncorrectFingerprintDio,
        placeHolderConfigurableFingerprintDio: placeHolderConfigurableSslFingerprintDio,
        placeHolderCorrectCertByteDio: correctCertificateByteDio,
        placeHolderIncorrectCertByteDio: incorrectCertificateByteDio,
        placeHolderDownloadableCertByteDio: downloadableSSLCertificateByteDio,
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
      appBar: AppBar(title: const Text('NETWORX')),
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
                      case "DIO_CLIENT_FOR_BURP_SUITE":
                        mainStore.getPostBurpSuiteById();
                        break;
                      case "FETCHED_POST_CORRECT_FINGERPRINT":
                        mainStore.getPostByIdCorrectFingerprint();
                        break;
                      case "FETCHED_POST_INCORRECT_FINGERPRINT":
                        mainStore.getPostByIdIncorrectFingerprint();
                        break;
                      case "RETRYABLE_INCORRECT_FINGERPRINT":
                        mainStore.getPostByIdRetryableFingerprint();
                        break;
                      case "FETCHED_POST_CONFIGURABLE_FINGERPRINT":
                        mainStore.getPostByIdConfigurableFingerprint();
                        break;
                      case "FETCHED_POST_CORRECT_CERTIFICATE_BYTE":
                        mainStore.getPostByIdCorrectCertByte();
                        break;
                      case "FETCHED_POST_INCORRECT_CERTIFICATE_BYTE":
                        mainStore.getPostByIdIncorrectCertByte();
                        break;
                      case "FETCHED_POST_DOWNLOADABLE_CERTIFICATE_BYTE":
                        mainStore.getPostByIdDownloadableCertByte();
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
