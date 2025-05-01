import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'transaction_menu_store.g.dart';

class TransactionMenuStore = TransactionMenuStoreBase
    with _$TransactionMenuStore;

enum MenuPage { transaction, pending }

abstract class TransactionMenuStoreBase with Store {
  final PageController pageController = PageController(initialPage: 0);

  @observable
  MenuPage currentPage = MenuPage.transaction;
  @action
  void setCurrentPage(MenuPage page) {
    currentPage = page;
    pageController.jumpToPage(page.index);
  }
}
