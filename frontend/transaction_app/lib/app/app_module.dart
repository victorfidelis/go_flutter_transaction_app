import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/modules/transaction/transaction_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module('/', module: TransactionModule());
  }
}
