import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_with_enchange_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDatasource datasource;

  TransactionRepositoryImpl(this.datasource);

  @override
  Future<Result<TransactionEntity>> createTransaction(TransactionEntity transaction) {
    return datasource.createTransaction(transaction);
  }

  @override
  Future<Result<TransactionWithExchangeEntity>> getTransaction(int id, String country) {
    return datasource.getTransaction(id, country);
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() {
    return datasource.getTransactions();
  }
}