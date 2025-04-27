import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_with_enchange_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionUsecase {
  final TransactionRepository transactionRepository;

  GetTransactionUsecase(this.transactionRepository);

  Future<Result<TransactionWithEnchangeEntity>> call(int id, String country) async {
    return await transactionRepository.getTransaction(id, country);
  }
}