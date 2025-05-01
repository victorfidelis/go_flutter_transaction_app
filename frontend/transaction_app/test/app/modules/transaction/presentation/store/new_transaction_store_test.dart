import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_app/app/core/errors/sqflite_errors.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/utils/number_formatter.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/create_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/delete_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/update_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/transaction/create_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/new_transaction_store.dart';

class MockCreateTransactionUsecase extends Mock
    implements CreateTransactionUsecase {}

class MockCreatePendingTransactionUsecase extends Mock
    implements CreatePendingTransactionUsecase {}

class MockUpdatePendingTransactionUsecase extends Mock
    implements UpdatePendingTransactionUsecase {}

class MockDeletePendingTransactionUsecase extends Mock
    implements DeletePendingTransactionUsecase {}

class FakeTransactionEntity extends Mock implements TransactionEntity {}

void main() {
  late NewTransactionStore store;
  late MockCreateTransactionUsecase mockCreateTransactionUsecase;
  late MockCreatePendingTransactionUsecase mockCreatePendingTransactionUsecase;
  late MockUpdatePendingTransactionUsecase mockUpdatePendingTransactionUsecase;
  late MockDeletePendingTransactionUsecase mockDeletePendingTransactionUsecase;

  final mockTransaction = TransactionEntity(
    id: 1,
    description: 'Transacao teste',
    amount: 100.0,
    date: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(FakeTransactionEntity());
  });

  setUp(() {
    mockCreateTransactionUsecase = MockCreateTransactionUsecase();
    mockCreatePendingTransactionUsecase = MockCreatePendingTransactionUsecase();
    mockUpdatePendingTransactionUsecase = MockUpdatePendingTransactionUsecase();
    mockDeletePendingTransactionUsecase = MockDeletePendingTransactionUsecase();

    store = NewTransactionStore(
      mockCreateTransactionUsecase,
      mockCreatePendingTransactionUsecase,
      mockUpdatePendingTransactionUsecase,
      mockDeletePendingTransactionUsecase,
    );
  });

  group('getters e setters', () {
    test('deve alterar a propriedade transactionSend', () {
      store.setTransactionSend(true);
      expect(store.transactionSend, true);

      store.setTransactionSend(false);
      expect(store.transactionSend, false);
    });

    test('deve alterar a propriedade description', () {
      store.setDescription('Nova descrição');
      expect(store.description, 'Nova descrição');
    });

    test('deve alterar a propriedade amount', () {
      store.setAmount('1.000,50');
      expect(store.amount, 1000.5);

      store.setAmount('');
      expect(store.amount, 0.0);
    });

    test('deve alterar a propriedade date', () {
      final now = DateTime.now();
      store.setDate(now);
      expect(store.date, now);
    });

    test('deve alterar as propriedade de error', () {
      store.setDescriptionError('Erro de descrição');
      expect(store.descriptionError, 'Erro de descrição');

      store.setAmountError('Erro no valor');
      expect(store.amountError, 'Erro no valor');

      store.setDateError('Erro na data');
      expect(store.dateError, 'Erro na data');

      store.setError('Erro genérico');
      expect(store.error, 'Erro genérico');
    });
  });

  group('createTransaction', () {
    test('Não deve processar a transação se houver erros', () async {
      // Nenhum campo configurado, logo deve ser disparado erros
      await store.createTransaction();

      expect(store.transactionSend, false);
    });

    test(
      'deve criar uma transação e deletar a transação pendente local quando válido',
      () async {
        store.setDescription(mockTransaction.description);
        store.setAmount(NumberFormatters.formatMoney(mockTransaction.amount));
        store.setDate(mockTransaction.date);
        store.pendingTransactionId = 1;

        when(
          () => mockCreateTransactionUsecase.call(any()),
        ).thenAnswer((_) async => Result.ok(mockTransaction));
        when(
          () => mockDeletePendingTransactionUsecase.call(any()),
        ).thenAnswer((_) async => Result.ok(true));

        await store.createTransaction();

        expect(store.transactionSend, true);
      },
    );

    test('não deve deletar quando a transação não estiver pendente', () async {
      store.setDescription(mockTransaction.description);
      store.setAmount(NumberFormatters.formatMoney(mockTransaction.amount));
      store.setDate(mockTransaction.date);
      store.pendingTransactionId = 0;

      when(
        () => mockCreateTransactionUsecase.call(any()),
      ).thenAnswer((_) async => Result.ok(mockTransaction));

      await store.createTransaction();

      verifyNever(() => mockDeletePendingTransactionUsecase.call(any()));
      expect(store.transactionSend, true);
    });
  });

  group('hasError', () {
    test(
      'deve retornar true e alterar os campos de erros quando a houver campos inválidos',
      () {
        // Nenhum campo configurado, logo deve hasError deve capturar essas falhas
        final result = store.hasError();

        expect(result, true);
        expect(store.descriptionError, isNotNull);
        expect(store.amountError, isNotNull);
        expect(store.dateError, isNotNull);
      },
    );

    test('deve retornar false quando todos os campos forem válidos', () {
      store.setDescription('Transacao valida');
      store.setAmount('100,50');
      store.setDate(DateTime.now());

      final result = store.hasError();

      expect(result, false);
      expect(store.descriptionError, isNull);
      expect(store.amountError, isNull);
      expect(store.dateError, isNull);
    });
  });

  group('savePendingTransaction', () {
    test(
      'não deve salvar transação como pendente quando houver campos inválidos',
      () async {
        // Nenhum campo configurado, logo a transação não está válida para ser salva
        final result = await store.savePendingTransaction();

        expect(result, false);
        verifyNever(() => mockCreatePendingTransactionUsecase.call(any()));
        verifyNever(() => mockUpdatePendingTransactionUsecase.call(any()));
      },
    );

    test(
      'deve criar a transação pendente localmente quando os campos forem válidos e a transação ainda não existir',
      () async {
        store.setDescription('Valid transaction');
        store.setAmount('100,50');
        store.setDate(DateTime.now());
        store.pendingTransactionId = 0;

        when(
          () => mockCreatePendingTransactionUsecase.call(any()),
        ).thenAnswer((_) async => Result.ok(true));

        final result = await store.savePendingTransaction();

        expect(result, true);
        verifyNever(() => mockUpdatePendingTransactionUsecase.call(any()));
      },
    );

    test(
      'deve atualizar a transação pendente quando os campos forem válidos e a transação já existir',
      () async {
        store.setDescription('Valid transaction');
        store.setAmount('100,50');
        store.setDate(DateTime.now());
        store.pendingTransactionId = 1;

        when(
          () => mockUpdatePendingTransactionUsecase.call(any()),
        ).thenAnswer((_) async => Result.ok(true));

        final result = await store.savePendingTransaction();

        expect(result, true);
        verify(() => mockUpdatePendingTransactionUsecase.call(any())).called(1);
        verifyNever(() => mockCreatePendingTransactionUsecase.call(any()));
      },
    );

    test('deve retornar false quando o usecase falhar', () async {
      store.setDescription('Valid transaction');
      store.setAmount('100,50');
      store.setDate(DateTime.now());
      store.pendingTransactionId = 0;

      when(
        () => mockCreatePendingTransactionUsecase.call(any()),
      ).thenAnswer((_) async => Result.error(GetDatabaseError('Falha local')));

      final result = await store.savePendingTransaction();

      expect(result, false);
    });
  });
}
