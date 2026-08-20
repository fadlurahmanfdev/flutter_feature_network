// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on MainStoreBase, Store {
  late final _$fetchNetworkStateAtom = Atom(
    name: 'MainStoreBase.fetchNetworkState',
    context: context,
  );

  @override
  FetchNetworkState get fetchNetworkState {
    _$fetchNetworkStateAtom.reportRead();
    return super.fetchNetworkState;
  }

  @override
  set fetchNetworkState(FetchNetworkState value) {
    _$fetchNetworkStateAtom.reportWrite(value, super.fetchNetworkState, () {
      super.fetchNetworkState = value;
    });
  }

  late final _$getPostByIdAsyncAction = AsyncAction(
    'MainStoreBase.getPostById',
    context: context,
  );

  @override
  Future<void> getPostById() {
    return _$getPostByIdAsyncAction.run(() => super.getPostById());
  }

  late final _$getPostBurpSuiteByIdAsyncAction = AsyncAction(
    'MainStoreBase.getPostBurpSuiteById',
    context: context,
  );

  @override
  Future<void> getPostBurpSuiteById() {
    return _$getPostBurpSuiteByIdAsyncAction.run(
      () => super.getPostBurpSuiteById(),
    );
  }

  late final _$getPostByIdCorrectFingerprintAsyncAction = AsyncAction(
    'MainStoreBase.getPostByIdCorrectFingerprint',
    context: context,
  );

  @override
  Future<void> getPostByIdCorrectFingerprint() {
    return _$getPostByIdCorrectFingerprintAsyncAction.run(
      () => super.getPostByIdCorrectFingerprint(),
    );
  }

  late final _$getPostByIdIncorrectFingerprintAsyncAction = AsyncAction(
    'MainStoreBase.getPostByIdIncorrectFingerprint',
    context: context,
  );

  @override
  Future<void> getPostByIdIncorrectFingerprint() {
    return _$getPostByIdIncorrectFingerprintAsyncAction.run(
      () => super.getPostByIdIncorrectFingerprint(),
    );
  }

  late final _$getPostByIdRetryableFingerprintAsyncAction = AsyncAction(
    'MainStoreBase.getPostByIdRetryableFingerprint',
    context: context,
  );

  @override
  Future<void> getPostByIdRetryableFingerprint() {
    return _$getPostByIdRetryableFingerprintAsyncAction.run(
      () => super.getPostByIdRetryableFingerprint(),
    );
  }

  late final _$getPostByIdConfigurableFingerprintAsyncAction = AsyncAction(
    'MainStoreBase.getPostByIdConfigurableFingerprint',
    context: context,
  );

  @override
  Future<void> getPostByIdConfigurableFingerprint() {
    return _$getPostByIdConfigurableFingerprintAsyncAction.run(
      () => super.getPostByIdConfigurableFingerprint(),
    );
  }

  late final _$getPostByIdCorrectCertByteAsyncAction = AsyncAction(
    'MainStoreBase.getPostByIdCorrectCertByte',
    context: context,
  );

  @override
  Future<void> getPostByIdCorrectCertByte() {
    return _$getPostByIdCorrectCertByteAsyncAction.run(
      () => super.getPostByIdCorrectCertByte(),
    );
  }

  late final _$getPostByIdIncorrectCertByteAsyncAction = AsyncAction(
    'MainStoreBase.getPostByIdIncorrectCertByte',
    context: context,
  );

  @override
  Future<void> getPostByIdIncorrectCertByte() {
    return _$getPostByIdIncorrectCertByteAsyncAction.run(
      () => super.getPostByIdIncorrectCertByte(),
    );
  }

  late final _$getPostByIdDownloadableCertByteAsyncAction = AsyncAction(
    'MainStoreBase.getPostByIdDownloadableCertByte',
    context: context,
  );

  @override
  Future<void> getPostByIdDownloadableCertByte() {
    return _$getPostByIdDownloadableCertByteAsyncAction.run(
      () => super.getPostByIdDownloadableCertByte(),
    );
  }

  @override
  String toString() {
    return '''
fetchNetworkState: ${fetchNetworkState}
    ''';
  }
}
