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
  Future<void> getPostById() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostById(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }

  @action
  Future<void> getPostByIdCorrectFingerprint() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdCorrectFingerprint(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }

  @action
  Future<void> getPostByIdIncorrectFingerprint() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdIncorrectFingerprint(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }

  @action
  Future<void> getPostByIdDynamicFingerprint() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdDynamicFingerprint(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }

  @action
  Future<void> getPostByIdCorrectCertByte() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdCorrectCertByte(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }

  @action
  Future<void> getPostByIdIncorrectCertByte() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdIncorrectCertByte(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }
}
