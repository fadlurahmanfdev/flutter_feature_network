import 'package:example/data/repository/repository_datasource.dart';
import 'package:example/data/state/generate_guest_token_state.dart';
import 'package:mobx/mobx.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  RepositoryDatasource repositoryDatasource;

  MainStoreBase({
    required this.repositoryDatasource,
  });

  @observable
  GenerateGuestTokenState generateGuestTokenState = GenerateGuestTokenIdleState();

  @action
  Future<void> generateGuestToken() async {
    try {
      generateGuestTokenState = GenerateGuestTokenLoadingState();
      final res = await repositoryDatasource.generateGuestToken();
      generateGuestTokenState = GenerateGuestTokenSuccessState();
    } catch (e) {
      generateGuestTokenState = GenerateGuestTokenFailedState();
    }
  }
}
