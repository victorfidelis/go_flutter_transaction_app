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

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      description: entity.description,
      amount: entity.amount,
      date: entity.date,
    );
  }

  factory TransactionModel.fromSqflite(Map map) {
    return TransactionModel(
      id: map['id'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      amount: map['amount'],
    );
  }
}
