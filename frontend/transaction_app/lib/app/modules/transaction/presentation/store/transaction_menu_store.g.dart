// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_menu_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransactionMenuStore on TransactionMenuStoreBase, Store {
  late final _$currentPageAtom =
      Atom(name: 'TransactionMenuStoreBase.currentPage', context: context);

  @override
  MenuPage get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(MenuPage value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$TransactionMenuStoreBaseActionController =
      ActionController(name: 'TransactionMenuStoreBase', context: context);

  @override
  void setCurrentPage(MenuPage page) {
    final _$actionInfo = _$TransactionMenuStoreBaseActionController.startAction(
        name: 'TransactionMenuStoreBase.setCurrentPage');
    try {
      return super.setCurrentPage(page);
    } finally {
      _$TransactionMenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPage: ${currentPage}
    ''';
  }
}
