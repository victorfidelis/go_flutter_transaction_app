import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/transaction_menu_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/pending_transaction_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/transaction_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_menu_buttom.dart';

class TransactionMenu extends StatefulWidget {
  const TransactionMenu({super.key});

  @override
  State<TransactionMenu> createState() => _TransactionMenuState();
}

class _TransactionMenuState extends State<TransactionMenu> {
  late final TransactionMenuStore store;

  @override
  void initState() {
    store = Modular.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: store.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [TransactionView(), PendingTransactionView()],
      ),
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: goToNewTransaction,
        tooltip: 'Nova transação',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Observer(
      builder: (context) {
        return BottomAppBar(
          child: Row(
            children: [
              Expanded(
                child: CustomMenuButtom(
                  onTap: () => store.setCurrentPage(MenuPage.transaction),
                  icon: Icons.monetization_on,
                  text: 'Transações',
                  isCurrent: store.currentPage == MenuPage.transaction,
                ),
              ),
              Expanded(
                child: CustomMenuButtom(
                  onTap: () => store.setCurrentPage(MenuPage.pending),
                  icon: Icons.autorenew,
                  text: 'Pendentes',
                  isCurrent: store.currentPage == MenuPage.pending,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void goToNewTransaction() {
    Modular.to.pushNamed('/new');
  }
}
