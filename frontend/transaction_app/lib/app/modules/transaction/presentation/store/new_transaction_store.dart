import 'package:mobx/mobx.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/delete_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/create_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/pending_transaction/update_pending_transaction_usecase.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/transaction/create_transaction_usecase.dart';

part 'new_transaction_store.g.dart';

class NewTransactionStore = NewTransactionStoreBase with _$NewTransactionStore;

abstract class NewTransactionStoreBase with Store {
  final CreateTransactionUsecase createTransactionUsecase;
  final CreatePendingTransactionUsecase createPendingTransactionUsecase;
  final UpdatePendingTransactionUsecase updatePendingTransactionUsecase;
  final DeletePendingTransactionUsecase deletePendingTransactionUsecase;

  NewTransactionStoreBase(
    this.createTransactionUsecase,
    this.createPendingTransactionUsecase,
    this.updatePendingTransactionUsecase,
    this.deletePendingTransactionUsecase,
  );

  int pendingTransactionId = 0;
  bool get _isPendingTransaction => pendingTransactionId > 0;

  @observable
  bool transactionSend = false;
  @action
  void setTransactionSend(bool value) => transactionSend = value;

  String description = '';
  void setDescription(String value) => description = value.trim();

  double amount = 0.0;
  void setAmount(String value) {
    if (value.isEmpty) {
      amount = 0;
    } else {
      amount = double.parse(value.replaceAll('.', '').replaceAll(',', '.'));
    }
  }

  DateTime? date;
  void setDate(DateTime value) => date = value;

  @observable
  String? descriptionError;
  @action
  void setDescriptionError(String? value) => descriptionError = value;

  @observable
  String? amountError;
  @action
  void setAmountError(String? value) => amountError = value;

  @observable
  String? dateError;
  @action
  void setDateError(String? value) => dateError = value;

  @observable
  String? error;
  @action
  void setError(String? value) => error = value;

  Future<void> createTransaction() async {
    if (hasError()) {
      return;
    }

    final transaction = TransactionEntity(
      description: description,
      amount: amount,
      date: date!,
    );

    createTransactionUsecase.call(transaction);

    // Transação pendente deve ser excluída ao ser enviada
    if (_isPendingTransaction) {
      await deletePendingTransactionUsecase.call(pendingTransactionId);
    }

    setTransactionSend(true);
  }

  bool hasError() {
    Map<String, String> errors = {};
    if (date == null) {
      errors['date'] = "Informe um valor de data";
    }

    final transaction = TransactionEntity(
      description: description,
      amount: amount,
      date: date ?? DateTime.now(),
    );

    errors.addAll(transaction.validateTransaction());
    if (errors.isNotEmpty) {
      _handleTextErrors(errors);
      return true;
    }
    return false;
  }

  void _handleTextErrors(Map<String, String> errors) {
    setDescriptionError(errors['description']);
    setAmountError(errors['amount']);
    setDateError(errors['date']);
    _resetGenericErrorsOnly();
  }

  void _resetGenericErrorsOnly() {
    setError(null);
  }

  // Salva a transação caso esteja valida e o usuário saia sem salvar
  Future<bool> savePendingTransaction() async {
    if (hasError()) {
      return false;
    }

    final transaction = TransactionEntity(
      id: pendingTransactionId,
      description: description,
      amount: amount,
      date: date!,
    );

    final Result<bool> result;
    if (_isPendingTransaction) {
      result = await updatePendingTransactionUsecase.call(transaction);
    } else {
      result = await createPendingTransactionUsecase.call(transaction);
    }

    return result.isOk;
  }
}
