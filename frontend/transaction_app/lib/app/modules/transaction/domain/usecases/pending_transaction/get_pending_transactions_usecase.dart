import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/pending_transaction_repository.dart';

class GetPendingTransactionsUsecase {
  final PendingTransactionRepository repository;

  GetPendingTransactionsUsecase(this.repository);
  
  Future<Result<List<TransactionEntity>>> call() async {
    return await repository.getTransactions(); 
  }
}