import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/services/nofitication_service.dart';
import 'package:transaction_app/app/core/widgets/custom_loading.dart';
import 'package:transaction_app/app/core/widgets/empty_list.dart';
import 'package:transaction_app/app/core/widgets/error_loading.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/pending_transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/transaction_card.dart';

class PendingTransactionView extends StatefulWidget {
  const PendingTransactionView({super.key});

  @override
  State<PendingTransactionView> createState() => _PendingTransactionViewState();
}

class _PendingTransactionViewState extends State<PendingTransactionView> {
  late final PendingTransactionStore store;

  @override
  void initState() {
    store = Modular.get();
    store.loadTransations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendentes de envio')),
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
          return EmptyList(message: 'Nenhuma transação pendente');
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
                    onTap: goToEditTransaction,
                    onLongTap: questionDelete,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void goToEditTransaction(TransactionEntity transaction) async {
    bool? doReload = await Modular.to.pushNamed('/new', arguments: transaction);
    if (doReload ?? false) {
      store.loadTransations();
    }
  }

  Future<void> questionDelete(TransactionEntity transaction) async {
    final notifications = Modular.get<NotificationService>();
    await notifications.showQuestionAlert(
      context: context,
      title: 'Deletar transação',
      content:
          'Deseja deletar a transação "${transaction.description}"?',
      confirmCallback: () => store.deleteTransaction(transaction.id),
    );
  }
}
