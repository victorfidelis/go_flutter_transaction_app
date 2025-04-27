import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/new_transaction_view.dart';
import 'package:transaction_app/app/modules/transaction/presentation/views/transaction_view.dart';

class TransactionModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (_) => const TransactionView());
    r.child('/new', child: (_) => const NewTransactionView());
  }
}
