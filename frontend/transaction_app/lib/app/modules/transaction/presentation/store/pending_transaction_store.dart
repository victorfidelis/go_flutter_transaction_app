import 'package:mobx/mobx.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/delete_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/get_pending_transactions_usecase.dart';

part 'pending_transaction_store.g.dart';

class PendingTransactionStore = PendingTransactionStoreBase
    with _$PendingTransactionStore;

abstract class PendingTransactionStoreBase with Store {
  final GetPendingTransactionsUsecase getPendingTransactionsUsecase;
  final DeletePendingTransactionUsecase deletePendingTransactionUsecase;

  PendingTransactionStoreBase(
    this.getPendingTransactionsUsecase,
    this.deletePendingTransactionUsecase,
  );

  @observable
  bool isLoading = false;
  @action
  void _setIsLoading(bool value) => isLoading = value;

  List<TransactionEntity> transactions = [];

  bool get noTransactions => transactions.isEmpty;

  String? errorMessage;
  bool get isError => errorMessage != null;

  Future<void> loadTransations() async {
    _setIsLoading(true);

    final result = await getPendingTransactionsUsecase.call();

    if (result.isError) {
      errorMessage = (result as Error).error.toString();
    } else {
      errorMessage = null;
      transactions = (result as Ok).value;
    }

    _setIsLoading(false);
  }

  Future<void> deleteTransaction(int id) async {
    _setIsLoading(true);

    final result = await deletePendingTransactionUsecase.call(id);

    if (result.isError) {
      _setIsLoading(false);
      errorMessage = (result as Error).error.toString();
      return;
    }

    await loadTransations();
  }
}
