import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/transaction/get_transactions_usecase.dart';

class MockTransactionRepository extends Mock implements TransactionRepository{}

void main() {
  late GetTransactionsUsecase usecase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    usecase = GetTransactionsUsecase(mockRepository);
  });

  group('GetTransactionsUsecase', () {
    final mockTransactions = [
      TransactionEntity(id: 2, amount: 100.0, description: 'Test 2', date: DateTime.now()),
      TransactionEntity(id: 1, amount: 200.0, description: 'Test 1', date: DateTime.now()),
      TransactionEntity(id: 3, amount: 300.0, description: 'Test 3', date: DateTime.now()),
    ];

    test('deve retornar a transação ordenada pelo id de forma descrescente', () async {
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => Result.ok(mockTransactions));

      final result = await usecase();

      expect(result.isOk, true);
      final transactions = (result as Ok).value;
      expect(transactions[0].id, 3);
      expect(transactions[1].id, 2);
      expect(transactions[2].id, 1);
    });

    test('deve retornar um erro quando o repository retornar um erro', () async {
      final mockError = Exception('Falha ao consultar transações');
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => Result.error(mockError));

      final result = await usecase();

      expect(result.isError, true);
      expect((result as Error).error, mockError);
    });

    test('deve retornar uma lista vazia quando o repository não retornar transações', () async {
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => Result.ok([]));

      final result = await usecase();

      expect(result.isOk, true);
      expect((result as Ok).value, isEmpty);
    });
  });
}