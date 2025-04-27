import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}