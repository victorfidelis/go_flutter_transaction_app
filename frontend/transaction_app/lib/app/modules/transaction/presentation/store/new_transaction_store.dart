import 'package:mobx/mobx.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/errors/transaction_error.dart';
import 'package:transaction_app/app/modules/transaction/domain/usecases/create_transaction_usecase.dart';

part 'new_transaction_store.g.dart';

class NewTransactionStore = NewTransactionStoreBase with _$NewTransactionStore;

abstract class NewTransactionStoreBase with Store {
  final CreateTransactionUsecase createTransactionUsecase;

  NewTransactionStoreBase(this.createTransactionUsecase);

  @observable
  bool transactionCreated = false;
  @action
  void setTransactionCreated(bool value) => transactionCreated = value;

  @observable
  bool isLoading = false;
  @action
  void setLoading(bool value) => isLoading = value;

  String description = '';
  void setDescription(String value) => description = value.trim();

  double amount = 0.0;
  void setAmount(String value) {
    if (value.isEmpty) {
      amount = 0;
    } else {
      amount = double.parse(value);
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
      return;
    }

    setLoading(true);

    final result = await createTransactionUsecase.call(transaction);
    _handleResult(result);

    setLoading(false);
  }

  void _handleTextErrors(Map<String, String> errors) {
    setDescriptionError(errors['description']);
    setAmountError(errors['amount']);
    setDateError(errors['date']);
    _resetGenericErrorsOnly();
  }

  void _handleResult(Result result) {
    if (result.isError) {
      final error = result as Error;
      if (error is CreateTransactionError) {
        setError((error as CreateTransactionError).message);
      } else {
        setError('Um erro inesperado ocorreu. Tente novamente mais tarde.');
      }
      _resetFieldErrorsOnly();
    } else {
      _resetAllErrors();
      setTransactionCreated(true);
    }
  }

  void _resetAllErrors() {
    _resetFieldErrorsOnly();
    _resetGenericErrorsOnly();
  }

  void _resetFieldErrorsOnly() {
    setDescriptionError(null);
    setAmountError(null);
    setDateError(null);
  }

  void _resetGenericErrorsOnly() {
    setError(null);
  }
}
