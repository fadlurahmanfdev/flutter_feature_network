import 'dart:io';
import 'dart:typed_data';

import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:example/data/dto/model/example_feature.dart';
import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/data/repository/repository_datasource.dart';
import 'package:example/data/state/fetch_network_state.dart';
import 'package:example/presentation/main_store.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:example/presentation/widget/info_bottomsheet.dart';
import 'package:example/presentation/widget/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:networx/networx.dart';

const _jsonPlaceholderBaseUrl = 'https://jsonplaceholder.typicode.com/';
const _jsonPlaceholderCertHash =
    '5c5106f35c5fd16f524258c4635db8b55ba89bf262ccca72e1dc0b7be5580231';
const _jsonPlaceholderSpkiHash = 'fj/LGYZh+mUuNimcCT6b6V6MLFW1SIzcsM4hgwSwVB4=';
const _incorrectCertHash =
    '065e3b66390a5d3c7ce51f27342442606453b3d98e4d4e97f5b708b59d190a0a';
const _incorrectSpkiHash = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Alice alice;

  @override
  void initState() {
    super.initState();
    alice = Alice();
    GetIt.I.registerSingleton(alice);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: alice.getNavigatorKey(),
      title: 'Networx',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MainPage(),
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
  final List<FeatureModel> features = ExampleFeature.values
      .map(FeatureModel.from)
      .toList(growable: false);
  List<ReactionDisposer> reactions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  void dispose() {
    for (final disposer in reactions) {
      disposer();
    }
    super.dispose();
  }

  AliceDioAdapter _aliceDioAdapter() {
    final adapter = AliceDioAdapter();
    GetIt.I.get<Alice>().addAdapter(adapter);
    return adapter;
  }

  Dio _jsonPlaceholderDio() {
    return Dio(BaseOptions(baseUrl: _jsonPlaceholderBaseUrl))
      ..interceptors.addAll([LoggerInterceptor(), _aliceDioAdapter()]);
  }

  Dio _pinnedDio({List<int>? certificateBytes, List<String>? pinningHash}) {
    final dio = _jsonPlaceholderDio();
    dio.httpClientAdapter = NetworxPinningClientAdapter(
      certificateBytes: certificateBytes,
      pinningHash: pinningHash,
    );
    return dio;
  }

  Future<List<int>?> _loadCertificateBytes(String assetPath) async {
    try {
      return await NetworxPinningUtils.getCertificateBytesFromAsset(
        assetPath: assetPath,
      );
    } catch (e) {
      debugPrint('Certificate asset missing: $assetPath ($e)');
      return null;
    }
  }

  Future<void> init() async {
    final jsonPlaceholderCertByte = await _loadCertificateBytes(
      'assets/jsonplaceholder.pem',
    );
    final wikipediaCertByte = await _loadCertificateBytes(
      'assets/wikipedia.pem',
    );

    final burpSuiteDio = _jsonPlaceholderDio();
    burpSuiteDio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (_, _, _) => true;
        client.findProxy = (uri) => 'PROXY 192.168.1.16:8888';
        return client;
      },
    );

    mainStore = MainStore(
      repositoryDatasource: RepositoryDatasourceImpl(
        fetchOkDio: _jsonPlaceholderDio(),
        correctCertificateHashDio: _pinnedDio(
          pinningHash: [_jsonPlaceholderCertHash],
        ),
        incorrectCertificateHashDio: _pinnedDio(
          pinningHash: [_incorrectCertHash],
        ),
        correctSpkiHashDio: _pinnedDio(pinningHash: [_jsonPlaceholderSpkiHash]),
        incorrectSpkiHashDio: _pinnedDio(pinningHash: [_incorrectSpkiHash]),
        correctCertBytesDio: _pinnedDio(certificateBytes: jsonPlaceholderCertByte),
        incorrectCertBytesDio:_pinnedDio(certificateBytes: wikipediaCertByte),
        burpSuiteDio: burpSuiteDio,
      ),
    );
    reactions = [
      reaction((p0) => mainStore.fetchNetworkState, (p0) {
        if (p0 is FetchNetworkLoadingState) {
          showLoading();
        } else if (p0 is FetchNetworkSuccessState) {
          Navigator.pop(context);
          showInfo(title: p0.title, desc: p0.message);
        } else if (p0 is FetchNetworkFailedState) {
          Navigator.pop(context);
          showInfo(title: p0.title, desc: p0.message);
        }
      }),
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: features.length,
              itemBuilder: (_, index) {
                final feature = features[index];
                return GestureDetector(
                  onTap: () => mainStore.run(feature.feature),
                  child: ItemFeatureWidget(feature: feature),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (_) {
        return InfoBottomsheet(title: title, desc: desc);
      },
    );
  }
}
