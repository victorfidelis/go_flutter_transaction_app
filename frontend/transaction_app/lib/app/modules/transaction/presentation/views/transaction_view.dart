import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/widgets/custom_loading.dart';
import 'package:transaction_app/app/core/widgets/empty_list.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/transaction_store.dart';
import 'package:transaction_app/app/core/widgets/error_loading.dart';
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
      appBar: AppBar(title: const Text('Transações')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        if (store.isLoading) {
          return CustomLoading();
        } else if (store.isError) {
          return ErrorLoading(
            errorMessage: store.errorMessage!,
            onRetry: store.loadTransations,
          );
        } else if (store.noTransactions) {
          return EmptyList(
            message: 'Nenhuma transação cadastrada',
            onAction: goToNewTransaction,
            actionText: 'Crie sua primeira transação',
          );
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
                  return TransactionCard(
                    transactions[index],
                    onTap: goToTransactionDetail,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void goToNewTransaction() async {
    bool? doReload = await Modular.to.pushNamed('/new');
    if (doReload ?? false) {
      store.loadTransations();
    }
  }

  void goToTransactionDetail(TransactionEntity transaction) {
    Modular.to.pushNamed('/detail', arguments: transaction);
  }
}
