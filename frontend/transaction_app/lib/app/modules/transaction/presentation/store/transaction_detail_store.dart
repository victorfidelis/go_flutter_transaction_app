import 'package:mobx/mobx.dart';
import 'package:transaction_app/app/core/constants/currencies.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_with_enchange_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:transaction_app/app/core/result/result.dart';

abstract class TransactionDetailStore with Store {
  final GetTransactionUsecase getTransactionUsecase;
  final TransactionEntity transaction;

  TransactionDetailStore({required this.getTransactionUsecase, required this.transaction}); 

  @observable
  bool isLoading = false;
  @action 
  void setIsLoading(bool value) => isLoading = value;

  String? errorMessage;
  bool get isError => errorMessage != null;

  late TransactionWithExchangeEntity transactionWithExchange;

  Currency currency = Currency.real;

  Future<void> getTransaction() async {
    setIsLoading(true);

    final result = await getTransactionUsecase.call(transaction.id, currencyEnumToText[currency]!);

    if (result.isError) {
      errorMessage = (result as Error).error.toString();
    } else {
      errorMessage = null;
      transactionWithExchange = (result as Ok).value;
    }

    setIsLoading(false);
  }
}