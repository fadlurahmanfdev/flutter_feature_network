import 'dart:developer';

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
      log("failed get post by id: ${e.title}");
      log("failed get post by id: ${e.desc}");
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
      print("masuk sini ${e.title} & ${e.desc}");
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
  Future<void> getPostByIdRetryableFingerprint() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdRetryableIncorrectFingerprint(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }

  @action
  Future<void> getPostByIdConfigurableFingerprint() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdConfigurableFingerprint(id: 1);
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

  @action
  Future<void> getPostByIdDownloadableCertByte() async {
    try {
      fetchNetworkState = FetchNetworkLoadingState();
      await repositoryDatasource.getPostByIdDownloadableCertByte(id: 1);
      fetchNetworkState = FetchNetworkSuccessState();
    } on FeatureException catch (e) {
      fetchNetworkState = FetchNetworkFailedState(exception: e);
    }
  }
}
