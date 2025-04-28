import 'package:dio/dio.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/data/models/transaction_model.dart';
import 'package:transaction_app/app/modules/transaction/data/models/transaction_with_exchange_model.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_with_enchange_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/errors/transaction_error.dart';

class TransactionDatasourceDio implements TransactionDatasource {
  final Dio dio;

  TransactionDatasourceDio(this.dio);

  @override
  Future<Result<TransactionEntity>> createTransaction(
    TransactionEntity transaction,
  ) async {
    final transactionModel = TransactionModel.fromEntity(transaction);
    try {
      final response = await dio.post(
        '/transactions',
        data: transactionModel.toJson(),
      );
      if (response.statusCode == 201) {
        return Result.ok(TransactionModel.fromJson(response.data));
      } else {
        return Result.error(
          CreateTransactionError(
            response.data['message'] ?? 'Falha ao criar transação',
          ),
        );
      }
    } on DioException catch (e) {
      return Result.error(CreateTransactionError('Erro criar transação: ${e.message}'));
    } catch (e) {
      return Result.error(
        CreateTransactionError('Erro ao criar transação: $e'),
      );
    }
  }

  @override
  Future<Result<TransactionWithExchangeEntity>> getTransaction(
    int id,
    String country,
  ) async {
    try {
      final response = await dio.get('/transactions/$id/$country');
      if (response.statusCode == 200) {
        return Result.ok(TransactionWithExchangeModel.fromJson(response.data));
      } else {
        return Result.error(
          GetTransactionError(
            response.data['message'] ?? 'Falha ao obter transação',
          ),
        );
      }
    } on DioException catch (e) {
      return Result.error(CreateTransactionError('Erro obter transação: ${e.message}'));
    } catch (e) {
      return Result.error(GetTransactionError('Erro ao obter transação: $e'));
    }
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() async {
    try {
      final response = await dio.get('/transactions');
      if (response.statusCode == 200) {
        final transactions =
            (response.data as List)
                .map((transaction) => TransactionModel.fromJson(transaction))
                .toList();
        return Result.ok(transactions);
      } else {
        return Result.error(
          GetTransactionError(
            response.data['message'] ?? 'Falha ao obter transações',
          ),
        );
      }
    } on DioException catch (e) {
      return Result.error(CreateTransactionError('Erro obter transações: ${e.message}'));
    } catch (e) {
      return Result.error(GetTransactionError('Erro ao obter transações: $e'));
    }
  }
}
