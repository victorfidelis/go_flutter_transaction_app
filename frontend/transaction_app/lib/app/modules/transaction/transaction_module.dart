import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/config/dio_config.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource_dio.dart';
import 'package:transaction_app/app/modules/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/create_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/new_transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/new_transaction_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/transaction_detail_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/transaction_view.dart';

class TransactionModule extends Module {
  @override
  void binds(i) {
    i.add<TransactionDatasource>(
      () => TransactionDatasourceDio(DioConfig.get()),
    );
    i.add<TransactionRepository>(
      () => TransactionRepositoryImpl(Modular.get()),
    );

    i.add<GetTransactionsUsecase>(() => GetTransactionsUsecase(Modular.get()));
    i.addSingleton<TransactionStore>(() => TransactionStore(Modular.get()));

    i.add<CreateTransactionUsecase>(
      () => CreateTransactionUsecase(Modular.get()),
    );
    i.add<NewTransactionStore>(() => NewTransactionStore(Modular.get()));

    i.add<GetTransactionUsecase>(() => GetTransactionUsecase(Modular.get()));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const TransactionView());
    r.child('/new', child: (_) => NewTransactionView());
    r.child(
      '/detail',
      child: (_) => TransactionDetailView(transaction: r.args.data),
    );
  }
}
