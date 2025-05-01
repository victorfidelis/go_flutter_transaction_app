import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/pending_transaction_repository.dart';

class GetPendingTransactionsUsecase {
  final PendingTransactionRepository repository;
  GetPendingTransactionsUsecase(this.repository);
  
  Future<Result<List<TransactionEntity>>> call() async {
    final result = await repository.getTransactions(); 
    if (result.isError) {
      return Result.error((result as Error).error);
    } 

    final List<TransactionEntity> transactions = (result as Ok).value;
    transactions.sort((t1, t2) => t2.id.compareTo(t1.id));
    
    return Result.ok(transactions); 
  }
}