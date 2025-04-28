// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_transaction_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewTransactionStore on NewTransactionStoreBase, Store {
  late final _$transactionCreatedAtom = Atom(
      name: 'NewTransactionStoreBase.transactionCreated', context: context);

  @override
  bool get transactionCreated {
    _$transactionCreatedAtom.reportRead();
    return super.transactionCreated;
  }

  @override
  set transactionCreated(bool value) {
    _$transactionCreatedAtom.reportWrite(value, super.transactionCreated, () {
      super.transactionCreated = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'NewTransactionStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$descriptionErrorAtom =
      Atom(name: 'NewTransactionStoreBase.descriptionError', context: context);

  @override
  String? get descriptionError {
    _$descriptionErrorAtom.reportRead();
    return super.descriptionError;
  }

  @override
  set descriptionError(String? value) {
    _$descriptionErrorAtom.reportWrite(value, super.descriptionError, () {
      super.descriptionError = value;
    });
  }

  late final _$amountErrorAtom =
      Atom(name: 'NewTransactionStoreBase.amountError', context: context);

  @override
  String? get amountError {
    _$amountErrorAtom.reportRead();
    return super.amountError;
  }

  @override
  set amountError(String? value) {
    _$amountErrorAtom.reportWrite(value, super.amountError, () {
      super.amountError = value;
    });
  }

  late final _$dateErrorAtom =
      Atom(name: 'NewTransactionStoreBase.dateError', context: context);

  @override
  String? get dateError {
    _$dateErrorAtom.reportRead();
    return super.dateError;
  }

  @override
  set dateError(String? value) {
    _$dateErrorAtom.reportWrite(value, super.dateError, () {
      super.dateError = value;
    });
  }

  late final _$errorAtom =
      Atom(name: 'NewTransactionStoreBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$NewTransactionStoreBaseActionController =
      ActionController(name: 'NewTransactionStoreBase', context: context);

  @override
  void setTransactionCreated(bool value) {
    final _$actionInfo = _$NewTransactionStoreBaseActionController.startAction(
        name: 'NewTransactionStoreBase.setTransactionCreated');
    try {
      return super.setTransactionCreated(value);
    } finally {
      _$NewTransactionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$NewTransactionStoreBaseActionController.startAction(
        name: 'NewTransactionStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$NewTransactionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescriptionError(String? value) {
    final _$actionInfo = _$NewTransactionStoreBaseActionController.startAction(
        name: 'NewTransactionStoreBase.setDescriptionError');
    try {
      return super.setDescriptionError(value);
    } finally {
      _$NewTransactionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmountError(String? value) {
    final _$actionInfo = _$NewTransactionStoreBaseActionController.startAction(
        name: 'NewTransactionStoreBase.setAmountError');
    try {
      return super.setAmountError(value);
    } finally {
      _$NewTransactionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDateError(String? value) {
    final _$actionInfo = _$NewTransactionStoreBaseActionController.startAction(
        name: 'NewTransactionStoreBase.setDateError');
    try {
      return super.setDateError(value);
    } finally {
      _$NewTransactionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? value) {
    final _$actionInfo = _$NewTransactionStoreBaseActionController.startAction(
        name: 'NewTransactionStoreBase.setError');
    try {
      return super.setError(value);
    } finally {
      _$NewTransactionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
transactionCreated: ${transactionCreated},
isLoading: ${isLoading},
descriptionError: ${descriptionError},
amountError: ${amountError},
dateError: ${dateError},
error: ${error}
    ''';
  }
}
