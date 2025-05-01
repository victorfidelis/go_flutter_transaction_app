import 'package:flutter/material.dart';
import 'package:transaction_app/app/core/utils/date_formatter.dart';
import 'package:transaction_app/app/core/utils/number_formatter.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;
  final Function(TransactionEntity) onTap;
  const TransactionCard(this.transaction, {super.key, required this.onTap});

  String get textAmount => NumberFormatters.formatMoney(transaction.amount);
  String get textDate => DateFormatters.formatDate(transaction.date);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(transaction),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Color(0x50000000),
              offset: const Offset(0, 4),
              blurStyle: BlurStyle.normal,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.description,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: Text(textDate)),
                Text('USD'),
                SizedBox(width: 10),
                Text(
                  textAmount,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
