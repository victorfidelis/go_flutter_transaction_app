
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/pending_transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/pending_transaction_repository.dart';

class PendingTransactionRepositoryImpl implements PendingTransactionRepository {
  final PendingTransactionDatasource datasource;

  PendingTransactionRepositoryImpl(this.datasource);

  @override
  Future<Result<bool>> createTransaction(TransactionEntity transaction) {
    return datasource.saveTransaction(transaction);
  }

  @override
  Future<Result<TransactionEntity>> getTransaction(int id) {
    return datasource.getTransaction(id);
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() {
    return datasource.getTransactions();
  }
  
  @override
  Future<Result<bool>> deleteTransaction(int id) {
    return datasource.deleteTransaction(id);
  }
  
  @override
  Future<Result<bool>> updateTransaction(TransactionEntity transaction) async {
    return await datasource.updateTransaction(transaction);
  }
}