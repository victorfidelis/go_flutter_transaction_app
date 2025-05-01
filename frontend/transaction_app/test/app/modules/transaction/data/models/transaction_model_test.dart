import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_app/app/modules/transaction/data/models/transaction_model.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';

void main() {
  const testId = 123;
  const testDescription = 'Test transaction';
  const testAmount = 100.50;
  final testDate = DateTime(2023, 5, 15);
  final testDateString = '2023-05-15';
  final testDateMillis = testDate.millisecondsSinceEpoch;

  group('Construtor', () {
    test('deve criar uma instância de TransactionModel válida', () {
      final transaction = TransactionModel(
        id: testId,
        description: testDescription,
        amount: testAmount,
        date: testDate,
      );

      expect(transaction.id, testId);
      expect(transaction.description, testDescription);
      expect(transaction.amount, testAmount);
      expect(transaction.date, testDate);
    });
  });

  group('fromJson Factory', () {
    test(
      'deve criar uma instância de TransactionModel válida através de um json',
      () {
        final json = {
          'id': testId,
          'description': testDescription,
          'amount': testAmount,
          'date': testDateString,
        };

        final transaction = TransactionModel.fromJson(json);

        expect(transaction.id, testId);
        expect(transaction.description, testDescription);
        expect(transaction.amount, testAmount);
        expect(transaction.date, testDate);
      },
    );

    test('deve lançar uma exceção quando o json estiver inválido', () {
      final invalidJson = {
        'id': testId,
        'description': testDescription,
        'amount': testAmount,
        'date': 'invalid-date',
      };

      expect(
        () => TransactionModel.fromJson(invalidJson),
        throwsFormatException,
      );
    });
  });

  group('fromEntity Factory', () {
    test(
      'deve criar uma instância de TransactionModel válida através de uma TransactionEntity',
      () {
        final entity = TransactionEntity(
          id: testId,
          description: testDescription,
          amount: testAmount,
          date: testDate,
        );

        final transaction = TransactionModel.fromEntity(entity);

        expect(transaction.id, testId);
        expect(transaction.description, testDescription);
        expect(transaction.amount, testAmount);
        expect(transaction.date, testDate);
      },
    );
  });

  group('fromSqflite Factory', () {
    test('deve criar uma instância de TransactionModel válida através de um sqflite map', () {
      final map = {
        'id': testId,
        'description': testDescription,
        'amount': testAmount,
        'date': testDateMillis,
      };

      final transaction = TransactionModel.fromSqflite(map);

      expect(transaction.id, testId);
      expect(transaction.description, testDescription);
      expect(transaction.amount, testAmount);
      expect(transaction.date, testDate);
    });
  });
}
