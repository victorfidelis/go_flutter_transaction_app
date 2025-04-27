class TransactionEntity {
  final int id;
  final String description;
  final double amount;
  final DateTime date;

  TransactionEntity({
    this.id = 0,
    required this.description,
    required this.amount,
    required this.date,
  });
}
