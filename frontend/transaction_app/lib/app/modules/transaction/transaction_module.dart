import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/config/dio_config.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource_dio.dart';
import 'package:transaction_app/app/modules/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/create_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/new_transaction_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/transaction_view.dart';

class TransactionModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<TransactionDatasource>(
      (i) => TransactionDatasourceDio(DioConfig.getDio()),
    );
    i.addSingleton<TransactionRepository>(
      (i) => TransactionRepositoryImpl(Modular.get()),
    );
    i.addSingleton<CreateTransactionUsecase>(
      (i) => CreateTransactionUsecase(Modular.get()),
    );
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const TransactionView());
    r.child('/new', child: (_) => const NewTransactionView());
  }
}
