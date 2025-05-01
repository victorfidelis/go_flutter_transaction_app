import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/pending_transaction_repository.dart';

class DeletePendingTransactionUsecase {
  final PendingTransactionRepository repository;
  DeletePendingTransactionUsecase(this.repository); 
  
  Future<Result<TransactionEntity>> call(int id) async {
    return await repository.deleteTransaction(id); 
  }
}
