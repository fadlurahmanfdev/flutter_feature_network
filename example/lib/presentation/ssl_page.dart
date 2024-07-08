import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/data/repository/repository_datasource.dart';
import 'package:example/presentation/main_store.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';
import 'package:get_it/get_it.dart';

class SslNetworkPage extends StatefulWidget {
  const SslNetworkPage({super.key});

  @override
  State<SslNetworkPage> createState() => _SslNetworkPageState();
}

class _SslNetworkPageState extends State<SslNetworkPage> {
  List<FeatureModel> features = [
    FeatureModel(
      title: 'SSL Network',
      desc: 'SSL Network',
      key: 'SSL_NETWORK',
    ),
  ];

  final store = MainStore(
    repositoryDatasource: RepositoryDatasourceImpl(
      sslDio: GetIt.I.get<Dio>(),
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SSL Network')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: features.length,
        itemBuilder: (_, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () async {
              switch (feature.key) {
                case "SSL_NETWORK":
                  break;
              }
            },
            child: ItemFeatureWidget(feature: feature),
          );
        },
      ),
    );
  }
}
