import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:transaction_app/app/core/config/sqflite_config.dart';
import 'package:transaction_app/app/core/errors/sqflite_errors.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/pending_transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/data/models/transaction_model.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';

class PendingTransactionDatasourceSqflite
    implements PendingTransactionDatasource {
  late Database database;
  String transactionsTable = '';

  PendingTransactionDatasourceSqflite();

  Future<Result<bool>> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    try {
      database = await sqfliteConfig.getDatabase();
      transactionsTable = sqfliteConfig.transactions;
      return Result.ok(true);
    } on DatabaseException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao acessar banco de dados local: $e'),
      );
    } on FileSystemException catch (e) {
      return Result.error(
        GetDatabaseError(
          'Falha ao acessar arquivo de banco de dados local: ${e.message}',
        ),
      );
    }
  }

  @override
  Future<Result<bool>> deleteTransaction(int id) async {
    final result = await _initDatabase();
    if (result.isError) {
      return Result.error((result as Error).error);
    }

    String deleteText =
        ''
        'DELETE FROM '
        '$transactionsTable '
        'WHERE '
        'id = ?';
    final params = [id];

    try {
      await database.rawDelete(deleteText, params);
      return Result.ok(true);
    } on DatabaseException catch (e) {
      return Result.error(GetDatabaseError('Falha ao apagar dados locais: $e'));
    } on FileSystemException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao apagar dados locais: ${e.message})'),
      );
    }
  }

  @override
  Future<Result<TransactionEntity>> getTransaction(int id) async {
    final result = await _initDatabase();
    if (result.isError) {
      return Result.error((result as Error).error);
    }

    String selectCommand =
        "SELECT "
        "tra.id, "
        "tra.description, "
        "tra.date, "
        "tra.amount "
        "FROM "
        "$transactionsTable tra "
        "WHERE "
        "id = ?";

    final params = [id];

    try {
      final map = await database.rawQuery(selectCommand, params);
      final transaction = TransactionModel.fromSqflite(map[0]);
      return Result.ok(transaction);
    } on DatabaseException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao capturar dados locais: $e'),
      );
    } on FileSystemException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao capturar dados locais: ${e.message})'),
      );
    }
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() async {
    final result = await _initDatabase();
    if (result.isError) {
      return Result.error((result as Error).error);
    }

    String selectCommand =
        "SELECT "
        "tra.id, "
        "tra.description, "
        "tra.date, "
        "tra.amount "
        "FROM "
        "$transactionsTable tra";

    try {
      final map = await database.rawQuery(selectCommand);
      final transactions =
          map.map((t) => TransactionModel.fromSqflite(t)).toList();
      return Result.ok(transactions);
    } on DatabaseException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao capturar dados locais: $e'),
      );
    } on FileSystemException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao capturar dados locais: ${e.message})'),
      );
    }
  }

  @override
  Future<Result<bool>> saveTransaction(TransactionEntity transaction) async {
    final result = await _initDatabase();
    if (result.isError) {
      return Result.error((result as Error).error);
    }

    String insert =
        "INSERT INTO $transactionsTable "
        "("
        "description, "
        "date, "
        "amount"
        ") "
        "VALUES (?, ?, ?, ?)";

    final params = [
      transaction.description.trim(),
      transaction.date.millisecondsSinceEpoch,
      transaction.amount,
    ];

    try {
      await database.rawInsert(insert, params);
      return Result.ok(true);
    } on DatabaseException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao inserir dados locais: $e'),
      );
    } on FileSystemException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao inserir dados locais: ${e.message})'),
      );
    }
  }

  @override
  Future<Result<bool>> updateTransaction(TransactionEntity transaction) async {
    final result = await _initDatabase();
    if (result.isError) {
      return Result.error((result as Error).error);
    }

    String insert =
        "UPDATE $transactionsTable "
        "SET "
        "description = ?, "
        "date = ?, "
        "amount = ? "
        "WHERE id = ?";

    final params = [
      transaction.description.trim(),
      transaction.date.millisecondsSinceEpoch,
      transaction.amount,
      transaction.id,
    ];

    try {
      await database.rawUpdate(insert, params);
      return Result.ok(true);
    } on DatabaseException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao atualizar dados locais: $e'),
      );
    } on FileSystemException catch (e) {
      return Result.error(
        GetDatabaseError('Falha ao atualizar dados locais: ${e.message})'),
      );
    }
  }
}
