
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/pending_transaction_repository.dart';

class CreatePendingTransactionUsecase {
  
  final PendingTransactionRepository repository;
  CreatePendingTransactionUsecase(this.repository);

  Future<Result<bool>> call(TransactionEntity transaction) async {
    return await repository.saveTransaction(transaction);
  }
}


