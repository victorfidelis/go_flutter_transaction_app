import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';

void main() {
  group('TransactionEntity', () {
    const validDescription = 'Transacao 10';
    const validAmount = 150.75;
    final validDate = DateTime.now();

    group('toMap', () {
      test('deve converter a transação para um map', () {
        final entity = TransactionEntity(
          id: 1,
          description: validDescription,
          amount: validAmount,
          date: validDate,
        );

        final result = entity.toMap();

        expect(result['id'], equals(1));
        expect(result['description'], equals(validDescription));
        expect(result['amount'], equals(validAmount));
        expect(result['date'], equals(validDate.toUtc().toIso8601String()));
      });
    });

    group('validateTransaction', () {
      test('deve retornat uma map vazio quando a transação for válida', () {
        final entity = TransactionEntity(
          description: validDescription,
          amount: validAmount,
          date: validDate,
        );

        final errors = entity.validateTransaction();

        expect(errors.isEmpty, isTrue);
      });

      test('deve detectar uma falha na descrição quando ela for vazia', () {
        final entity = TransactionEntity(
          description: '',
          amount: validAmount,
          date: validDate,
        );

        final errors = entity.validateTransaction();

        expect(errors['description'], equals('Descrição é obrigatória'));
      });

      test('deve detectar uma falha na descrição quando ela ultrapassar 50 caracteres', () {
        final entity = TransactionEntity(
          description: 'a' * 51,
          amount: validAmount,
          date: validDate,
        );

        final errors = entity.validateTransaction();

        expect(errors['description'], equals('Descrição deve ter no máximo 50 caracteres'));
      });

      test('deve detectar uma falha na descrição quando possuir caracteres inválidos', () {
        final entity = TransactionEntity(
          description: 'Compra @ mercado!',
          amount: validAmount,
          date: validDate,
        );

        final errors = entity.validateTransaction();

        expect(errors['description'], equals('Descrição deve conter apenas letras e números'));
      });

      test('deve detectar uma falha no campo "amount" quando ele for zero ou negativo', () {
        final entity1 = TransactionEntity(
          description: validDescription,
          amount: 0,
          date: validDate,
        );
        final entity2 = TransactionEntity(
          description: validDescription,
          amount: -10,
          date: validDate,
        );

        final errors1 = entity1.validateTransaction();
        final errors2 = entity2.validateTransaction();

        expect(errors1['amount'], equals('Valor deve ser maior que zero'));
        expect(errors2['amount'], equals('Valor deve ser maior que zero'));
      });

      test('deve detectar uma falha no campo "amount" quando ele ultrapassar 99999,99', () {
        final entity = TransactionEntity(
          description: validDescription,
          amount: 100000,
          date: validDate,
        );

        final errors = entity.validateTransaction();

        expect(errors['amount'], equals('Valor máximo é USD 99.999,99'));
      });

      test('deve acumular múltiplos erros', () {
        final entity = TransactionEntity(
          description: '',
          amount: -100000,
          date: validDate,
        );

        final errors = entity.validateTransaction();

        expect(errors.length, equals(2));
        expect(errors['description'], isNotNull);
        expect(errors['amount'], isNotNull);
      });
    });
  });
}