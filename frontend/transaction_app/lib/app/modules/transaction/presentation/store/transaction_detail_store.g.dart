// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransactionDetailStore on TransactionDetailStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'TransactionDetailStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$TransactionDetailStoreBaseActionController =
      ActionController(name: 'TransactionDetailStoreBase', context: context);

  @override
  void setIsLoading(bool value) {
    final _$actionInfo = _$TransactionDetailStoreBaseActionController
        .startAction(name: 'TransactionDetailStoreBase.setIsLoading');
    try {
      return super.setIsLoading(value);
    } finally {
      _$TransactionDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading}
    ''';
  }
}
