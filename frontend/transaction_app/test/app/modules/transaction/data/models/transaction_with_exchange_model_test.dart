import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_app/app/modules/transaction/data/models/transaction_with_exchange_model.dart';

void main() {
  const testId = 123;
  const testDescription = 'Transacao 2';
  const testAmount = 150.75;
  final testDate = DateTime(2023, 5, 15);
  const testCountry = 'US';
  const testCurrency = 'USD';
  const testExchangeRate = 5.25;
  const testConvertedAmount = 791.44;
  final testEffectiveDate = DateTime(2023, 5, 16);

  group('Construtor', () {
    test('Deve criar uma instância válida', () {
      final transaction = TransactionWithExchangeModel(
        id: testId,
        description: testDescription,
        amount: testAmount,
        date: testDate,
        country: testCountry,
        currency: testCurrency,
        exchangeRate: testExchangeRate,
        convertedAmount: testConvertedAmount,
        effectiveDate: testEffectiveDate,
      );

      expect(transaction.id, testId);
      expect(transaction.description, testDescription);
      expect(transaction.amount, testAmount);
      expect(transaction.date, testDate);
      expect(transaction.country, testCountry);
      expect(transaction.currency, testCurrency);
      expect(transaction.exchangeRate, testExchangeRate);
      expect(transaction.convertedAmount, testConvertedAmount);
      expect(transaction.effectiveDate, testEffectiveDate);
    });
  });

  group('fromJson Factory', () {
    test('Deve criar uma instância válida através de um json', () {
      final json = {
        'id': testId,
        'description': testDescription,
        'original_value': testAmount,
        'date': testDate.toIso8601String(),
        'country': testCountry,
        'currency': testCurrency,
        'exchange_rate': testExchangeRate,
        'converted_value': testConvertedAmount,
        'effective_date': testEffectiveDate.toIso8601String(),
      };

      final transaction = TransactionWithExchangeModel.fromJson(json);

      expect(transaction.id, testId);
      expect(transaction.description, testDescription);
      expect(transaction.amount, testAmount);
      expect(transaction.date, testDate);
      expect(transaction.country, testCountry);
      expect(transaction.currency, testCurrency);
      expect(transaction.exchangeRate, testExchangeRate);
      expect(transaction.convertedAmount, testConvertedAmount);
      expect(transaction.effectiveDate, testEffectiveDate);
    });

    test('Deve lançar um erro se o json for inválido', () {
      final invalidJson = {
        'id': testId,
        'description': testDescription,
        'original_value': testAmount,
        'date': 'invalid-date',
        'country': testCountry,
        'currency': testCurrency,
        'exchange_rate': testExchangeRate,
        'converted_value': testConvertedAmount,
        'effective_date': testEffectiveDate.toIso8601String(),
      };

      expect(() => TransactionWithExchangeModel.fromJson(invalidJson), throwsFormatException);
    });
  });
}