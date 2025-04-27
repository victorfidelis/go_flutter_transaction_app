import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';

class TransactionWithEnchangeEntity extends TransactionEntity {
  final String country;
  final String currency;
  final double exchangeRate;
  final double convertedAmount;
  final DateTime effectiveDate;

  TransactionWithEnchangeEntity({
    required super.id,
    required super.description,
    required super.amount,
    required super.date,
    required this.country,
    required this.currency,
    required this.exchangeRate,
    required this.convertedAmount,
    required this.effectiveDate,
  });
}
