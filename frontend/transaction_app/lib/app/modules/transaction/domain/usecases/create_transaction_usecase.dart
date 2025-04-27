import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/utils/text_validations.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/errors/validation_error.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';

class CreateTransactionUsecase {
  final TransactionRepository repository;
  CreateTransactionUsecase(this.repository);

  Future<Result<TransactionEntity>> call(TransactionEntity transaction) async {

    final errors = _validateTransaction(transaction);
    if (errors.isNotEmpty) {
      return Result.error(ValidationError(errors));
    }

    return await repository.createTransaction(transaction);
  }
}

Map<String, String> _validateTransaction(TransactionEntity transaction) {
  final errors = <String, String>{};

  if (transaction.description.isEmpty) {
    errors['description'] = 'Descrição é obrigatória';
  }
  if (transaction.description.length > 50) {
    errors['description'] = 'Descrição deve ter no máximo 50 caracteres';
  }
  if (TextValidations.isAlphanumWithSpaces(transaction.description)) {
    errors['description'] = 'Descrição deve conter apenas letras e números';
  }
  if (transaction.amount <= 0) {
    errors['amount'] = 'Valor deve ser maior que zero';
  }
  if (transaction.amount > 99999.99) {
    errors['amount'] = 'Valor deve ser menor que USD 99.999,99';
  }

  return errors;
}