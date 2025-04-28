import 'package:mobx/mobx.dart';
import 'package:transaction_app/app/core/result/result.dart';
import 'package:transaction_app/app/core/result/result_extensions.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/domain/errors/transaction_error.dart';
import 'package:transaction_app/app/modules/transaction/domain/errors/validation_error.dart';
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
  void setDescription(String value) => description = value;

  double amount = 0.0;
  void setAmount(double value) => amount = value;

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
    if (date == null) {
      setDateError("Informe um valor de data");
      return;
    }

    final transaction = TransactionEntity(
      description: description,
      amount: amount,
      date: date!,
    );

    setLoading(true);

    final result = await createTransactionUsecase.call(transaction);
    _handleResult(result);

    setLoading(false);
  }

  void _handleResult(Result result) {
    if (result.isError) {
      if (result is ValidationError) {
        final validationError = result as ValidationError;
        setDescriptionError(validationError.errors['description']);
        setAmountError(validationError.errors['amount']);
        setDateError(validationError.errors['date']);
        _resetGenericErrorsOnly();
      } else {
        if (result is CreateTransactionError) {
          setError((result as CreateTransactionError).message);
        } else {
          setError('Um erro inesperado ocorreu. Tente novamente mais tarde.');
        }
        _resetFieldErrorsOnly();
      }
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
