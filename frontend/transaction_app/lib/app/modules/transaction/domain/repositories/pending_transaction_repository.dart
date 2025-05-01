
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';

abstract class PendingTransactionRepository {
  Future<Result<List<TransactionEntity>>> getTransactions();
  Future<Result<bool>> saveTransaction(TransactionEntity transaction);
  Future<Result<bool>> updateTransaction(TransactionEntity transaction);
  Future<Result<TransactionEntity>> getTransaction(int id);
  Future<Result<TransactionEntity>> deleteTransaction(int id);
}