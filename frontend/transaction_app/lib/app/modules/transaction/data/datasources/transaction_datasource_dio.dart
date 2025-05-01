import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      final result = await _sendTransactionMapInIsolate(
        transactionModel.toMap(),
        dio.options.baseUrl,
      );

      final statusCode = result['statusCode'];
      final data = result['data'];

      if (statusCode == 201) {
        return Result.ok(TransactionModel.fromJson(data));
      } else {
        return Result.error(
          CreateTransactionError(data['message'] ?? 'Falha ao criar transação'),
        );
      }
    } catch (e) {
      return Result.error(
        CreateTransactionError('Erro ao criar transação: $e'),
      );
    }
  }

  Future<Map<String, dynamic>> _sendTransactionMapInIsolate(
    Map<String, dynamic> transactionMap,
    String baseUrl,
  ) async {
    if (kIsWeb) {
      return await _sendTransactionMap(transactionMap, baseUrl);
    } else {
      return await Isolate.run(
        () async => _sendTransactionMap(transactionMap, baseUrl),
      );
    }
  }

  static Future<Map<String, dynamic>> _sendTransactionMap(
    Map<String, dynamic> transactionMap,
    String baseUrl,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));

    final response = await dio.post(
      '/transactions',
      data: transactionMap,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    return {'statusCode': response.statusCode, 'data': response.data};
  }

  @override
  Future<Result<TransactionWithExchangeEntity>> getTransaction(
    int id,
    String currency,
  ) async {
    try {
      final response = await dio.get('/transactions/$id/$currency');
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
      if (e.response != null &&
          e.response!.data.containsKey('error') &&
          e.response!.data['error'] == 'no data found') {
        return Result.error(
          CreateTransactionError('Não foi encontrada taxa de câmbio.'),
        );
      }
      return Result.error(
        CreateTransactionError('Erro obter transação: ${e.message}'),
      );
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
      String message;
      if (e.type.name == 'connectionTimeout') {
        message =
            'O servidor não está respondendo. Entre em contato com o suporte.';
      } else if (e.type.name == 'badResponse') {
        message =
            'Ocorreu uma falha inesperado no servidor. Entre em contato com o suporte.';
      } else {
        message =
            'Um erro inesperado ocorreu ao buscar dados no servidor. Entre em contato com o suporte: ${e.message}';
      }
      return Result.error(CreateTransactionError(message));
    } catch (e) {
      return Result.error(
        GetTransactionError(
          'Um erro inesperado ocorreu. Entre em contato com o suporte: $e',
        ),
      );
    }
  }
}
