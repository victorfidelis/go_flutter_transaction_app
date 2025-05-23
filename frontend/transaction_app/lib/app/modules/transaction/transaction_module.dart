import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/config/dio_config.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/pending_transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/pending_transaction_datasource_sqflite.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource.dart';
import 'package:transaction_app/app/modules/transaction/data/datasources/transaction_datasource_dio.dart';
import 'package:transaction_app/app/modules/transaction/data/repositories/pending_transaction_repository_impl.dart';
import 'package:transaction_app/app/modules/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/pending_transaction_repository.dart';
import 'package:transaction_app/app/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/delete_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/get_pending_transactions_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/create_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/update_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/transaction/create_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/transaction/get_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/transaction/get_transactions_usecase.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/new_transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/pending_transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/transaction_menu_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/new_transaction_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/transaction_detail_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/transaction_menu.dart';

class TransactionModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<TransactionMenuStore>(TransactionMenuStore.new);

    // Dependências para dados remotos
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
    i.add<GetTransactionUsecase>(() => GetTransactionUsecase(Modular.get()));

    // Dependências para dados locais
    i.add<PendingTransactionDatasource>(
      () => PendingTransactionDatasourceSqflite(),
    );
    i.add<PendingTransactionRepository>(
      () => PendingTransactionRepositoryImpl(Modular.get()),
    );
    i.add<GetPendingTransactionsUsecase>(
      () => GetPendingTransactionsUsecase(Modular.get()),
    );
    i.add<CreatePendingTransactionUsecase>(
      () => CreatePendingTransactionUsecase(Modular.get()),
    );
    i.add<UpdatePendingTransactionUsecase>(
      () => UpdatePendingTransactionUsecase(Modular.get()),
    );
    i.add<DeletePendingTransactionUsecase>(
      () => DeletePendingTransactionUsecase(Modular.get()),
    );
    i.addSingleton<PendingTransactionStore>(
      () => PendingTransactionStore(Modular.get(), Modular.get()),
    );

    // Store para criar uma nova transação
    // Aqui também ocorrerá a gravação de transações pendentes de forma local
    i.add<NewTransactionStore>(() {
      return NewTransactionStore(
        Modular.get(),
        Modular.get(),
        Modular.get(),
        Modular.get(),
      );
    });
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => TransactionMenu());
    r.child('/new', child: (_) => 
    NewTransactionView(transaction: r.args.data));
    r.child(
      '/detail',
      child: (_) => TransactionDetailView(transaction: r.args.data),
    );
  }
}
