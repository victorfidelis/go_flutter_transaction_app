import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_with_enchange_entity.dart';

class TransactionWithExchangeModel extends TransactionWithExchangeEntity {
  TransactionWithExchangeModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.date,
    required super.country,
    required super.currency,
    required super.exchangeRate,
    required super.convertedAmount,
    required super.effectiveDate,
  });

  factory TransactionWithExchangeModel.fromJson(Map<String, dynamic> json) {
    return TransactionWithExchangeModel(
      id: json['id'],
      description: json['description'],
      amount: json['original_value'].toDouble(),
      date: DateTime.parse(json['date']),
      country: json['country'],
      currency: json['currency'],
      exchangeRate: json['exchange_rate'].toDouble(),
      convertedAmount: json['converted_value'].toDouble(),
      effectiveDate: DateTime.parse(json['effective_date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'original_value': amount,
      'date': date.toIso8601String(),
      'country': country,
      'currency': currency,
      'exchange_rate': exchangeRate,
      'converted_value': convertedAmount,
      'effective_date': effectiveDate.toIso8601String(),
    };
  }
}