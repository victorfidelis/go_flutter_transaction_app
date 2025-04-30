

import 'package:mobx/mobx.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/get_transactions_usecase.dart';
part 'transaction_store.g.dart';

class TransactionStore = TransactionStoreBase with _$TransactionStore;

abstract class TransactionStoreBase with Store {
  final GetTransactionsUsecase getTransactionsUsecase;

  TransactionStoreBase(this.getTransactionsUsecase);

  @observable
  bool isLoading = false; 
  @action
  void _setIsLoading(bool value) => isLoading = value;

  List<TransactionEntity> transactions = [];

  bool get noTransactions => transactions.isEmpty;

  String errorMessage = '';

  Future<void> loadTransations() async {
    _setIsLoading(true);

    final result = await getTransactionsUsecase.call();

    if (result.isError) {
      errorMessage = (result as Error).error.toString();
    } else {
      errorMessage = '';
      transactions = (result as Ok).value;
    }

    _setIsLoading(false);
  }
}