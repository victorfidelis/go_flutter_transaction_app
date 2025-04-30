import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/widgets/custom_loading.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/transaction_card.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  late final TransactionStore store;

  @override
  @override
  void initState() {
    store = Modular.get();
    store.loadTransations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction View')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/new');
        },
        tooltip: 'New Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        if (store.isLoading) {
          return Center(child: CustomLoading());
        } else {
          return _buildTransactionsList();
        }
      },
    );
  }

  Widget _buildTransactionsList() {
    final transactions = store.transactions;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length + 1,
              itemBuilder: (context, index) {
                if (transactions.length == index) {
                  return SizedBox(height: 90);
                } else {
                  return TransactionCard(transactions[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
