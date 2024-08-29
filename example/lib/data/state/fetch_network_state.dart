import 'package:example/data/dto/model/feature_exception.dart';

abstract class FetchNetworkState {}

class FetchNetworkIdleState extends FetchNetworkState {}

class FetchNetworkLoadingState extends FetchNetworkState {}

class FetchNetworkSuccessState extends FetchNetworkState {}

class FetchNetworkFailedState extends FetchNetworkState {
  FeatureException exception;

  FetchNetworkFailedState({required this.exception});
}