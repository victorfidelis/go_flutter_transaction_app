import 'package:transaction_app/app/core/utils/text_validations.dart';

class TransactionEntity {
  final int id;
  final String description;
  final double amount;
  final DateTime date;

  TransactionEntity({
    this.id = 0,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, String> validateTransaction() {
    final errors = <String, String>{};

    if (description.isEmpty) {
      errors['description'] = 'Descrição é obrigatória';
    } else if (description.length > 50) {
      errors['description'] = 'Descrição deve ter no máximo 50 caracteres';
    } else if (!TextValidations.isAlphanumWithSpaces(description)) {
      errors['description'] = 'Descrição deve conter apenas letras e números';
    }

    if (amount <= 0) {
      errors['amount'] = 'Valor deve ser maior que zero';
    } else if (amount > 99999.99) {
      errors['amount'] = 'Valor máximo é USD 99.999,99';
    }

    return errors;
  }
}
