abstract class FetchNetworkState {}

class FetchNetworkIdleState extends FetchNetworkState {}

class FetchNetworkLoadingState extends FetchNetworkState {}

class FetchNetworkSuccessState extends FetchNetworkState {
  final String title;
  final String message;

  FetchNetworkSuccessState({
    required this.title,
    required this.message,
  });
}

class FetchNetworkFailedState extends FetchNetworkState {
  final String title;
  final String message;

  FetchNetworkFailedState({
    required this.title,
    required this.message,
  });
}
