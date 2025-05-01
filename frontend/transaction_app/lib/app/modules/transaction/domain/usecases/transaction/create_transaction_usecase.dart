import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';

class CreateTransactionUsecase {
  final TransactionRepository repository;
  CreateTransactionUsecase(this.repository);

  Future<Result<TransactionEntity>> call(TransactionEntity transaction) async {
    return await repository.createTransaction(transaction);
  }
}
