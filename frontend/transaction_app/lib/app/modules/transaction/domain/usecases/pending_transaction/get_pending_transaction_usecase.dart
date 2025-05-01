
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/pending_transaction_repository.dart';

class GetPendingTransactionUsecase {
  final PendingTransactionRepository transactionRepository;

  GetPendingTransactionUsecase(this.transactionRepository);

  Future<Result<TransactionEntity>> call(int id) async {
    return await transactionRepository.getTransaction(id);
  }
}