// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransactionStore on TransactionStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'TransactionStoreBase.isLoading', context: context);

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

  late final _$TransactionStoreBaseActionController =
      ActionController(name: 'TransactionStoreBase', context: context);

  @override
  void _setIsLoading(bool value) {
    final _$actionInfo = _$TransactionStoreBaseActionController.startAction(
        name: 'TransactionStoreBase._setIsLoading');
    try {
      return super._setIsLoading(value);
    } finally {
      _$TransactionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading}
    ''';
  }
}
