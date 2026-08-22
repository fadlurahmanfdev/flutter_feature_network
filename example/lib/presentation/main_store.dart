import 'dart:developer';

import 'package:example/data/dto/model/example_feature.dart';
import 'package:example/data/dto/model/feature_exception.dart';
import 'package:example/data/repository/repository_datasource.dart';
import 'package:example/data/state/fetch_network_state.dart';
import 'package:mobx/mobx.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  RepositoryDatasource repositoryDatasource;

  MainStoreBase({
    required this.repositoryDatasource,
  });

  @observable
  FetchNetworkState fetchNetworkState = FetchNetworkIdleState();

  @action
  Future<void> run(ExampleFeature feature) async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.fetchPost(feature);
      fetchNetworkState = FetchNetworkSuccessState(
        title: feature.successTitle,
        message: feature.successMessage,
      );
    } on FeatureException catch (e) {
      log('feature ${feature.name} failed: ${e.title} ${e.desc}');
      fetchNetworkState = FetchNetworkFailedState(
        title: feature.blockedTitle,
        message: feature.blockedMessage,
      );
    }
  }
}
