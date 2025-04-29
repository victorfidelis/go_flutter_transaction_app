import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/services/nofitication_service.dart';
import 'package:transaction_app/app/core/services/notification_service_impl.dart';
import 'package:transaction_app/app/modules/transaction/transaction_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<NotificationService>(NotificationsServiceImpl.new);
  }

  @override
  void routes(r) {
    r.module('/', module: TransactionModule());
  }
}
