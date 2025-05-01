import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_with_enchange_entity.dart';

abstract class TransactionDatasource {
  Future<Result<TransactionEntity>> createTransaction(TransactionEntity transaction);
  Future<Result<List<TransactionEntity>>> getTransactions();
  Future<Result<TransactionWithExchangeEntity>> getTransaction(int id, String currency);
}