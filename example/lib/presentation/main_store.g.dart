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

  late final _$runAsyncAction = AsyncAction(
    'MainStoreBase.run',
    context: context,
  );

  @override
  Future<void> run(ExampleFeature feature) {
    return _$runAsyncAction.run(() => super.run(feature));
  }

  @override
  String toString() {
    return '''
fetchNetworkState: ${fetchNetworkState}
    ''';
  }
}
